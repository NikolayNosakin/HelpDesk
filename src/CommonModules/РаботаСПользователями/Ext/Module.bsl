﻿
// Возвращает подразделение для переданного пользователя.
//
Функция ПолучитьПодразделение(Пользователь) Экспорт 

	Если Не ЗначениеЗаполнено(Пользователь) Тогда 
		Возврат Справочники.СтруктураПредприятия.ПустаяСсылка();
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОПользователях.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
	|ГДЕ
	|	СведенияОПользователях.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Справочники.СтруктураПредприятия.ПустаяСсылка();
	КонецЕсли;

	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Подразделение;

КонецФункции

// Возвращает должность для переданного пользователя.
//
Функция ПолучитьДолжность(Пользователь) Экспорт 

	Если Не ЗначениеЗаполнено(Пользователь) Тогда 
		Возврат Справочники.Должности.ПустаяСсылка();
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОПользователях.Должность КАК Должность
	|ИЗ
	|	РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
	|ГДЕ
	|	СведенияОПользователях.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);

	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Справочники.Должности.ПустаяСсылка();
	КонецЕсли;

	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Должность;

КонецФункции

// Возвращает руководителя для переданного пользователя.
//
Функция ПолучитьРуководителя(Пользователь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОПользователях.Подразделение КАК Подразделение
	|ИЗ
	|	РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
	|ГДЕ
	|	СведенияОПользователях.Пользователь = &Пользователь";
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда 
		Возврат Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Подразделение = Выборка.Подразделение;
	Если Подразделение.Руководитель <> Пользователь Тогда 
		Возврат Подразделение.Руководитель;
	КонецЕсли;		
	
	Пока ЗначениеЗаполнено(Подразделение.Родитель)  Цикл
		Подразделение = Подразделение.Родитель;
		Если Подразделение.Руководитель <> Пользователь Тогда 
			Возврат Подразделение.Руководитель;
		КонецЕсли;
	КонецЦикла;	
	
	Возврат Подразделение.Руководитель;
	
КонецФункции	

// По части наименования формирует список для выбора пользователей и ролей пользователей
// Параметры:
//		Текст - часть наименования, по которому выполняется поиск
//		ВключатьАвтоподстановку - флаг, показывающий необходимость использования функций автоподстановки для получения значений для выбора
// Возвращает:
//		СписокЗначений, содержащий ссылки на найденные по части наименования объекты
Функция СформироватьДанныеВыбораИсполнителя(Текст, ВключатьАвтоподстановку = Ложь, ВключатьКонтактныеЛицаИКорреспонденты = Ложь,
	ВключатьЛичныхАдресатов = Ложь) Экспорт
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Пользователи.Ссылка КАК Ссылка,
	|	СведенияОПользователях.Подразделение КАК Подразделение
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
	|		ПО Пользователи.Ссылка = СведенияОПользователях.Пользователь
	|ГДЕ
	|	Пользователи.Наименование ПОДОБНО &Текст
	|	И Пользователи.Недействителен = ЛОЖЬ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РолиИсполнителей.Ссылка,
	|	NULL
	|ИЗ
	|	Справочник.РолиИсполнителей КАК РолиИсполнителей
	|ГДЕ
	|	РолиИсполнителей.Наименование ПОДОБНО &Текст";
	
	Если ВключатьКонтактныеЛицаИКорреспонденты Тогда 
		Запрос.Текст = Запрос.Текст + 
		"
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Корреспонденты.Ссылка,
		|	NULL
		|ИЗ
		|	Справочник.Контрагенты КАК Корреспонденты
		|ГДЕ
		|	Корреспонденты.Наименование ПОДОБНО &Текст
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КонтактныеЛица.Ссылка,
		|	КонтактныеЛица.Владелец
		|ИЗ
		|	Справочник.КонтактныеЛица КАК КонтактныеЛица
		|ГДЕ
		|	КонтактныеЛица.Наименование ПОДОБНО &Текст";
	КонецЕсли;
	
	Если ВключатьЛичныхАдресатов Тогда 
		Запрос.Текст = Запрос.Текст + 
		"
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЛичныеАдресаты.Ссылка,
		|	NULL
		|ИЗ
		|	Справочник.ЛичныеАдресаты КАК ЛичныеАдресаты
		|ГДЕ
		|	ЛичныеАдресаты.Наименование ПОДОБНО &Текст
		| И
		|	ЛичныеАдресаты.Пользователь = &Пользователь";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Подразделение) Тогда 
			ДанныеВыбора.Добавить(Выборка.Ссылка, Строка(Выборка.Ссылка) + " (" + Строка(Выборка.Подразделение) + ")");
		Иначе	
			ДанныеВыбора.Добавить(Выборка.Ссылка);
		КонецЕсли;	
	КонецЦикла;	
		
	Возврат ДанныеВыбора;
	
КонецФункции	

Функция ПолучитьПользователейПодразделения(ПодразделениеСсылка) Экспорт
	
	ЗапросПользователей = Новый Запрос;
	ЗапросПользователей.Текст = 
		"ВЫБРАТЬ
		|	СправочникПользователи.Ссылка
		|ИЗ
		|	Справочник.Пользователи КАК СправочникПользователи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
		|		ПО СправочникПользователи.Ссылка = СведенияОПользователях.Пользователь
		|ГДЕ
		|	СведенияОПользователях.Подразделение = &Подразделение
		|	И СправочникПользователи.ПометкаУдаления = ЛОЖЬ";
		
	ЗапросПользователей.УстановитьПараметр("Подразделение", ПодразделениеСсылка);
	
	Возврат ЗапросПользователей.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

// формирует параметры роли для формы выбора или подбора исполнителя
Функция ПолучитьПараметрыРоли(Роль, Подразделение) Экспорт
	
	ТипыОсновногоОбъектаАдресации = Неопределено;
	Если Роль.ТипыОсновногоОбъектаАдресации.ТипЗначения <> Неопределено Тогда
		ТипыОсновногоОбъектаАдресации = Роль.ТипыОсновногоОбъектаАдресации.ТипЗначения.Типы();
	КонецЕсли;	
	
	ТипыДополнительногоОбъектаАдресации = Неопределено;
	Если Роль.ТипыДополнительногоОбъектаАдресации.ТипЗначения <> Неопределено Тогда
		ТипыДополнительногоОбъектаАдресации = Роль.ТипыДополнительногоОбъектаАдресации.ТипЗначения.Типы();
	КонецЕсли;	
	
	ИспользуетсяСОбъектамиАдресации = Роль.ИспользуетсяСОбъектамиАдресации;
	ИспользуетсяБезОбъектовАдресации = Роль.ИспользуетсяБезОбъектовАдресации;
	
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	
	Если Подразделение <> Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		               |	ИсполнителиЗадач.ОсновнойОбъектАдресации
		               |ИЗ
		               |	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
		               |		ПО ИсполнителиЗадач.Исполнитель = СведенияОПользователях.Пользователь
		               |ГДЕ
		               |	ИсполнителиЗадач.РольИсполнителя = &РольИсполнителя
		               |	И СведенияОПользователях.Подразделение = &Подразделение";
		
		Запрос.УстановитьПараметр("РольИсполнителя", Роль);
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		
		Таблица = Запрос.Выполнить().Выгрузить();
		Если Таблица.Количество() = 1 Тогда
			ОсновнойОбъектАдресации = Таблица[0].ОсновнойОбъектАдресации;
		КонецЕсли;	
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		               |	ИсполнителиЗадач.ДополнительныйОбъектАдресации
		               |ИЗ
		               |	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователях КАК СведенияОПользователях
		               |		ПО ИсполнителиЗадач.Исполнитель = СведенияОПользователях.Пользователь
		               |ГДЕ
		               |	ИсполнителиЗадач.РольИсполнителя = &РольИсполнителя
		               |	И СведенияОПользователях.Подразделение = &Подразделение";
		
		Запрос.УстановитьПараметр("РольИсполнителя", Роль);
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
		
		Таблица = Запрос.Выполнить().Выгрузить();
		Если Таблица.Количество() = 1 Тогда
			ДополнительныйОбъектАдресации = Таблица[0].ДополнительныйОбъектАдресации;
		КонецЕсли;	
		
	КонецЕсли;	
	
	Возврат Новый Структура("ТипыОсновногоОбъектаАдресации, ТипыДополнительногоОбъектаАдресации, ИспользуетсяСОбъектамиАдресации, ИспользуетсяБезОбъектовАдресации, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации",
		ТипыОсновногоОбъектаАдресации, ТипыДополнительногоОбъектаАдресации, ИспользуетсяСОбъектамиАдресации, 
		ИспользуетсяБезОбъектовАдресации, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации);
	
КонецФункции

// Выбирает всех пользователей из регистра ИсполнителиЗадач по роли, объекту адресации, дополнительному объекту адресации
Функция ПолучитьПользователейРоли(Роль, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ИсполнителиЗадач.Исполнитель
	               |ИЗ
	               |	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
	               |ГДЕ
	               |	ИсполнителиЗадач.РольИсполнителя = &РольИсполнителя
	               |	И ИсполнителиЗадач.ОсновнойОбъектАдресации = &ОсновнойОбъектАдресации
	               |	И ИсполнителиЗадач.ДополнительныйОбъектАдресации = &ДополнительныйОбъектАдресации";
	
	Запрос.УстановитьПараметр("РольИсполнителя", Роль);
	Запрос.УстановитьПараметр("ОсновнойОбъектАдресации", ОсновнойОбъектАдресации);
	Запрос.УстановитьПараметр("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресации);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Возврат Таблица;
	
КонецФункции

//Получает список пользователей, входящих в группу пользователей
Функция ПолучитьПользователейГруппыПользователей(ГруппаПользователей, СУчетомИерархии = Истина) Экспорт 
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ГруппыПользователей.Ссылка
		|ИЗ
		|	Справочник.ГруппыПользователей КАК ГруппыПользователей
		|ГДЕ";
		
	Если СУчетомИерархии Тогда
		Запрос.Текст = Запрос.Текст + " ГруппыПользователей.Ссылка В ИЕРАРХИИ (&Ссылка)";	
	Иначе
		Запрос.Текст = Запрос.Текст + " ГруппыПользователей.Ссылка = &Ссылка";
	КонецЕсли;
	Запрос.УстановитьПараметр("Ссылка", ГруппаПользователей);
    МассивГрупп = Запрос.Выполнить().Выгрузить();	
	Для Каждого Группа из МассивГрупп Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	СоставыГруппПользователей.Пользователь
			|ИЗ
			|	РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
			|ГДЕ
			|	СоставыГруппПользователей.ГруппаПользователей = &ГруппаПользователей";

		Запрос.УстановитьПараметр("ГруппаПользователей", Группа.Ссылка);

		РезультатЗапроса = Запрос.Выполнить().Выгрузить();
		
		Для Каждого ЭлементСостава Из РезультатЗапроса Цикл
			Если Результат.Найти(ЭлементСостава.Пользователь) = Неопределено Тогда
				Результат.Добавить(ЭлементСостава.Пользователь);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

	Возврат Результат;
	
КонецФункции
