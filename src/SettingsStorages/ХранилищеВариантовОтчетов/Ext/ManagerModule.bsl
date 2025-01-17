﻿////////////////////////////////////////////////////////////////////////////////
// Программный интерфейс для совместимости со стандартным хранилищем
//

// Удаляет настройку из хранилища.
// 
// Параметры:
//   КлючОбъекта  - (...) Ключ объекта настройки. 
//       |- (Неопределено) - Удаляются настройки всех отчетов.
//       |- (Строка)       - Полное имя отчета с точкой.
//   КлючНастроек - (...) Ключ удаляемых настроек.
//       |- (Неопределено) - Удаляются все варианты отчета.
//       |- (Строка)       - Ключ варианта отчета.
//   Пользователь - (...) Пользователь, настройки которого удаляются.
//       |- (Неопределено)                   - Удаляются настройки всех пользователей
//       |- (Строка)                         - Имя пользователя ИБ
//       |- (УникальныйИдентификатор)        - Идентификатор пользователя ИБ
//       |- (ПользовательИнформационнойБазы) - Пользователь ИБ
//       |- (СправочникСсылка.Пользователи)  - Пользователь
//
// Подробнее - см. СтандартноеХранилищеНастроекМенеджер.Удалить()
//
Процедура Удалить(КлючОбъекта, КлючНастроек, Пользователь) Экспорт
	
	ВариантыОтчетов.ПравоИзмененияВариантов(КлючОбъекта, Истина);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Варианты.Ссылка
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Варианты
	|ГДЕ
	|	Варианты.КлючОбъекта = &КлючОбъекта
	|	И Варианты.Администратор = &Администратор
	|	И Варианты.Администратор.ИдентификаторПользователяИБ = &GUID
	|	И Варианты.КлючВарианта = &КлючВарианта
	|	И Варианты.ПометкаУдаления = ЛОЖЬ
	|	И Варианты.ТипВариантаОтчета <> &ТипПредопределенный
	|	И Варианты.ТипВариантаОтчета <> &ТипОтчет";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТипПредопределенный", Перечисления.ТипыВариантовОтчетов.Предопределенный);
	Запрос.УстановитьПараметр("ТипОтчет",            Перечисления.ТипыВариантовОтчетов.Отчет);
	
	Если КлючОбъекта = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Варианты.КлючОбъекта = &КлючОбъекта", "ИСТИНА");
	Иначе
		Запрос.УстановитьПараметр("КлючОбъекта", КлючОбъекта);
	КонецЕсли;
	
	Если КлючНастроек = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.КлючВарианта = &КлючВарианта", "");
	Иначе
		Запрос.УстановитьПараметр("КлючВарианта", КлючНастроек);
	КонецЕсли;
	
	Если Пользователь = Неопределено Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.Администратор = &Администратор", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.Администратор.ИдентификаторПользователяИБ = &GUID", "");
	
	ИначеЕсли ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
		
		Запрос.УстановитьПараметр("Администратор", Пользователь);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.Администратор.ИдентификаторПользователяИБ = &GUID", "");
		
	Иначе
		
		Если ТипЗнч(Пользователь) = Тип("УникальныйИдентификатор") Тогда
			ИдентификаторПользователя = Пользователь;
		Иначе
			Если ТипЗнч(Пользователь) = Тип("Строка") Тогда
		        ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(Пользователь);
				Если ПользовательИБ = Неопределено Тогда
					Возврат;
				КонецЕсли;
			ИначеЕсли ТипЗнч(Пользователь) = Тип("ПользовательИнформационнойБазы") Тогда
				ПользовательИБ = Пользователь;
			Иначе
				Возврат;
			КонецЕсли;
			ИдентификаторПользователя = ПользовательИБ.УникальныйИдентификатор;
		КонецЕсли;
		
		Запрос.УстановитьПараметр("GUID", ИдентификаторПользователя);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Варианты.Администратор = &Администратор", "");
		
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ВариантОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ВариантОбъект.УстановитьПометкуУдаления(Истина);
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Получает список настроек из хранилища. Значениями элементов списка являются ключи настроек.
// 
// Параметры:
//   КлючОбъекта  - (Строка) Полное имя отчета с точкой.
//   Пользователь - (...) Пользователь, настройки которого получаются. Необязательный параметр.
//       |- (Неопределено)                   - Получаются настройки текущего пользователя
//       |- (Строка)                         - Имя пользователя ИБ
//       |- (УникальныйИдентификатор)        - Идентификатор пользователя ИБ
//       |- (ПользовательИнформационнойБазы) - Пользователь ИБ
//       |- (СправочникСсылка.Пользователи)  - Пользователь
//
// Отличия от механизма платформы:
//   Вместо права "АдминистрированиеДанных" проверяются права доступа к отчету.
// 
// Возвращаемое значение: 
//   (СписокЗначений) - список вариантов отчета
//       |- Значение      - (Строка) Ключ варианта.
//       |- Представление - (Строка) Представление варианта.
// 
Функция ПолучитьСписок(КлючОбъекта, Пользователь = Неопределено) Экспорт
	Результат = Новый СписокЗначений;
	
	ВариантыОтчетов.ПравоИзмененияВариантов(КлючОбъекта, Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Варианты.КлючВарианта,
	|	Варианты.Представление
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Варианты
	|ГДЕ
	|	Варианты.КлючОбъекта = &КлючОбъекта
	|	И Варианты.Администратор = &Администратор
	|	И Варианты.Администратор.ИдентификаторПользователяИБ = &GUID
	|	И Варианты.ПометкаУдаления = ЛОЖЬ
	|	И Варианты.ТипВариантаОтчета <> &ТипПредопределенный
	|	И Варианты.ТипВариантаОтчета <> &ТипОтчет";
	Запрос.УстановитьПараметр("КлючОбъекта",         КлючОбъекта);
	Запрос.УстановитьПараметр("ТипПредопределенный", Перечисления.ТипыВариантовОтчетов.Предопределенный);
	Запрос.УстановитьПараметр("ТипОтчет",            Перечисления.ТипыВариантовОтчетов.Отчет);
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Если Пользователь = Неопределено Тогда
		
		Запрос.УстановитьПараметр("Администратор", ТекущийПользователь);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Варианты.Администратор.ИдентификаторПользователяИБ = &GUID", "");
	
	ИначеЕсли ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
		
		Запрос.УстановитьПараметр("Администратор", Пользователь);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Варианты.Администратор.ИдентификаторПользователяИБ = &GUID", "");
		
	Иначе
		
		Если ТипЗнч(Пользователь) = Тип("УникальныйИдентификатор") Тогда
			ИдентификаторПользователя = Пользователь;
		Иначе
			Если ТипЗнч(Пользователь) = Тип("Строка") Тогда
		        ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(Пользователь);
				Если ПользовательИБ = Неопределено Тогда
					Возврат Результат;
				КонецЕсли;
			ИначеЕсли ТипЗнч(Пользователь) = Тип("ПользовательИнформационнойБазы") Тогда
				ПользовательИБ = Пользователь;
			Иначе
				Возврат Результат;
			КонецЕсли;
			ИдентификаторПользователя = ПользовательИБ.УникальныйИдентификатор;
		КонецЕсли;
		
		Запрос.УстановитьПараметр("GUID", ИдентификаторПользователя);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И Варианты.Администратор = &Администратор", "");
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаВариантов = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из ТаблицаВариантов Цикл
		Результат.Добавить(СтрокаТаблицы.КлючВарианта, СтрокаТаблицы.Представление);
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// События
//

// Обработчик чтения настроек варианта отчета
// 
// Параметры:
//   КлючОбъекта      - (Строка) Полное имя отчета с точкой
//   КлючНастроек     - (Строка) Ключ варианта отчета
//   Настройки        - (*) Настройки варианта отчета
//   ОписаниеНастроек - (ОписаниеНастроек)
//   Пользователь     - (Строка) Имя пользователя ИБ
//       Не используется, так как подсистема "Варианты отчетов" не разделяет варианты по авторам.
//       Уникальность хранения и выборки гарантируется уникальностью пар ключей отчетов и вариантов.
//
Процедура ОбработкаЗагрузки(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, Пользователь)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВариантыОтчетов.Наименование,
	|	ВариантыОтчетов.ХранилищеЗначений
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	ВариантыОтчетов.КлючОбъекта = &КлючОбъекта
	|	И ВариантыОтчетов.КлючВарианта = &КлючВарианта";
	Запрос.УстановитьПараметр("КлючОбъекта", КлючОбъекта);
	Запрос.УстановитьПараметр("КлючВарианта", КлючНастроек);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ОписаниеНастроек.Представление = Выборка.Наименование;
		Настройки = Выборка.ХранилищеЗначений.Получить();
	КонецЕсли;

	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Обработчик записи настроек варианта отчета
// 
// Параметры:
//   КлючОбъекта      - (Строка) Полное имя отчета с точкой
//   КлючНастроек     - (Строка) Ключ варианта отчета
//   Настройки        - (*) Настройки варианта отчета
//   ОписаниеНастроек - (ОписаниеНастроек, Неопределено)
//   Пользователь     - (Строка, Неопределено) Имя пользователя ИБ
//       Не используется, так как подсистема "Варианты отчетов" не разделяет варианты по авторам.
//       Уникальность хранения и выборки гарантируется уникальностью пар ключей отчетов и вариантов.
//
Процедура ОбработкаСохранения(КлючОбъекта, КлючНастроек, Настройка, ОписаниеНастроек, Пользователь)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВариантыОтчетов.Ссылка
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	ВариантыОтчетов.КлючОбъекта = &КлючОбъекта
	|	И ВариантыОтчетов.КлючВарианта = &КлючВарианта";
	Запрос.УстановитьПараметр("КлючОбъекта",  КлючОбъекта);
	Запрос.УстановитьПараметр("КлючВарианта", КлючНастроек);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ВариантОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ВариантОбъект.ХранилищеЗначений = Новый ХранилищеЗначения(Настройка);
		Если ОписаниеНастроек <> Неопределено Тогда
			ВариантОбъект.Наименование = ОписаниеНастроек.Представление;
		КонецЕсли;
		ВариантОбъект.Записать();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Обработчик получения описания настроек варианта отчета
// 
// Параметры:
//   КлючОбъекта      - (Строка) Полное имя отчета с точкой
//   КлючНастроек     - (Строка) Ключ варианта отчета
//   ОписаниеНастроек - (ОписаниеНастроек)
//   Пользователь     - (Строка, Неопределено) Имя пользователя ИБ
//       Не используется, так как подсистема "Варианты отчетов" не разделяет варианты по авторам.
//       Уникальность хранения и выборки гарантируется уникальностью пар ключей отчетов и вариантов.
//
Процедура ОбработкаПолученияОписания(КлючОбъекта, КлючНастроек, ОписаниеНастроек, Пользователь)
	
	Если ОписаниеНастроек = Неопределено Тогда
		ОписаниеНастроек = Новый ОписаниеНастроек;
	КонецЕсли;
	
	ОписаниеНастроек.КлючОбъекта   = КлючОбъекта;
	ОписаниеНастроек.КлючНастроек  = КлючНастроек;
	
	Если ТипЗнч(Пользователь) = Тип("Строка") Тогда
		ОписаниеНастроек.Пользователь  = Пользователь;
	КонецЕсли;
	
	Если НЕ ВариантыОтчетов.ПравоИзмененияВариантов(КлючОбъекта) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Варианты.Представление КАК Представление
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Варианты
	|ГДЕ
	|	Варианты.КлючОбъекта = &КлючОбъекта
	|	И Варианты.КлючВарианта = &КлючВарианта";
	Запрос.УстановитьПараметр("КлючОбъекта",  КлючОбъекта);
	Запрос.УстановитьПараметр("КлючВарианта", КлючНастроек);
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаЗначений = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ТаблицаЗначений.Количество() = 1 Тогда
		ОписаниеНастроек.Представление = ТаблицаЗначений[0].Представление;
	КонецЕсли;
КонецПроцедуры

// Обработчик установки описания настроек варианта отчета
// 
// Параметры:
//   КлючОбъекта      - (Строка) Полное имя отчета с точкой
//   КлючНастроек     - (Строка) Ключ варианта отчета
//   ОписаниеНастроек - (ОписаниеНастроек)
//   Пользователь     - (Строка) Имя пользователя ИБ.
//       Не используется, так как подсистема "Варианты отчетов" не разделяет варианты по авторам.
//       Уникальность хранения и выборки гарантируется уникальностью пар ключей отчетов и вариантов.
//
Процедура ОбработкаУстановкиОписания(КлючОбъекта, КлючНастроек, ОписаниеНастроек, Пользователь)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Варианты.Ссылка
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Варианты
	|ГДЕ
	|	Варианты.КлючОбъекта = &КлючОбъекта
	|	И Варианты.КлючВарианта = &КлючВарианта";
	Запрос.УстановитьПараметр("КлючОбъекта",  КлючОбъекта);
	Запрос.УстановитьПараметр("КлючВарианта", КлючНастроек);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ВариантОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ВариантОбъект.Наименование = ОписаниеНастроек.Представление;
		ВариантОбъект.Записать();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

