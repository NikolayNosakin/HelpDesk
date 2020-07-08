////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая()
		ИЛИ НЕ Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		
		Элементы.ПараметрыАдминистрированияИнформационнойБазы.Видимость = Ложь;
		Элементы.ЗапретитьРаботуРегламентныхЗаданий.Видимость = Ложь;
		Элементы.ГруппаComcntr.Видимость = Ложь;
		Элементы.ГруппаПараметры.Видимость = Ложь;
	КонецЕсли;
	
	ПолучитьПараметрыБлокировки();
	НачальныйСтатусЗапретаРаботыПользователей = Объект.ВременноЗапретитьРаботуПользователей;
	ОбновитьСтраницуНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КлиентПодключенЧерезВебСервер = ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер();
	Если РаботаПользователейЗавершается = Истина Тогда
		Элементы.ГруппаРежим.ТекущаяСтраница = Элементы.СтраницаСостоянияБлокировки;
		ОбновитьСтраницуСостояния(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НазванияСоединенийИБ = "";
	ТолькоКлиентскиеПриложения = АктивныТолькоКлиентскиеПриложения(НазванияСоединенийИБ);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		// Проверка возможности принудительно завершить сеансы при работе в файловом режиме.
		Если НЕ ТолькоКлиентскиеПриложения Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Имеются активные сеансы, которые не могут быть завершены принудительно. Блокировка не установлена.
					|%1'"), 
				НазванияСоединенийИБ);
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;
		
		КоличествоСеансов = СтрЧислоСтрок(НазванияСоединенийИБ);
		
	Иначе	
		// Проверка возможности принудительно завершить сеансы при работе с клиента через веб-сервер.
		// Невозможно установить блокировку, на сервере не установлена ОС Microsoft Windows и не включено разделение (локальный режим работы).
		Если НЕ ТолькоКлиентскиеПриложения И Не ОбщегоНазначенияПовтИсп.РазделениеВключено() И КлиентПодключенЧерезВебСервер
			И Не СоединенияИБПовтИсп.ПараметрыОтключенияСеансов().WindowsПлатформаНаСервере Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Имеются активные сеансы, которые не могут быть завершены принудительно (т.к. сервер работает под управлением ОС, отличной от Microsoft Windows). Блокировка не установлена.
					|%1'"), 
				НазванияСоединенийИБ);
			ВызватьИсключение ТекстСообщения;
		КонецЕсли;	
		
		КоличествоСеансов = ПолучитьСеансыИнформационнойБазы().Количество();
		
	КонецЕсли;
	
	// проверки возможности установки блокировки
	Если Объект.НачалоДействияБлокировки > Объект.ОкончаниеДействияБлокировки 
		И ЗначениеЗаполнено(Объект.ОкончаниеДействияБлокировки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Дата окончания блокировки не может быть меньше даты начала блокировки. Блокировка не установлена.'"),,
			"Объект.ОкончаниеДействияБлокировки",,Отказ);
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.НачалоДействияБлокировки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указана дата начала блокировки.'"),,	"Объект.НачалоДействияБлокировки",,Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗавершениеРаботыПользователей" Тогда
		КоличествоСеансов = Параметр.КоличествоСеансов;
		ОбновитьСостояниеБлокировки(ЭтотОбъект);
		Если Параметр.Статус = "Готово" Тогда
			Закрыть();
		ИначеЕсли Параметр.Статус = "Ошибка" Тогда
			ПоказатьПредупреждение(Новый ОписаниеОповещения("ОбработкаОповещенияЗавершение", ЭтотОбъект), НСтр("ru = 'Не удалось завершить работу всех активных пользователей.
				|Подробности см. в Журнале регистрации.'"), 30);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "Запись_ПараметрыАдминистрированияИБ" Тогда
		ПолучитьПараметрыБлокировки(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияЗавершение(ДополнительныеПараметры) Экспорт
	
	Закрыть();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура АктивныеПользователи(Команда)
	
	ОткрытьФорму("Обработка.АктивныеПользователи.Форма",, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыАдминистрированияИнформационнойБазы(Команда)
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыАдминистрированияСервернойИБ");
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	
	ОчиститьСообщения();
	
	Объект.ВременноЗапретитьРаботуПользователей = Не НачальныйСтатусЗапретаРаботыПользователей;
	Если Объект.ВременноЗапретитьРаботуПользователей Тогда
		
		КоличествоСеансов = 1;
		Попытка
			Если Не ПроверитьПредусловияБлокировки() Тогда
				Возврат;
			КонецЕсли;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
		КонецПопытки;
		
		ЗаголовокВопроса = НСтр("ru = 'Блокировка работы пользователей'");
		Если КоличествоСеансов > 1 И Объект.НачалоДействияБлокировки < ОбщегоНазначенияКлиент.ДатаСеанса() + 5 * 60 Тогда
			ТекстВопроса = НСтр("ru = 'Сейчас будет завершена работа всех активных пользователей.
				|Указано слишком близкое время начала действия блокировки, к которому пользователи могут не успеть сохранить все свои данные и завершить работу.
				|Рекомендуется установить время начала на 5 минут относительно текущего времени.
				|
				|• Да, чтобы скорректировать время начала и продолжить (рекомендуется);
				|• Нет, чтобы продолжить без корректировки.'");
			Ответ = Неопределено;

			ПоказатьВопрос(Новый ОписаниеОповещения("ПрименитьЗавершение2", ЭтотОбъект, Новый Структура("ЗаголовокВопроса, ТекстВопроса", ЗаголовокВопроса, ТекстВопроса)), ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена,,, ЗаголовокВопроса);
            Возврат;
		ИначеЕсли Объект.НачалоДействияБлокировки > ОбщегоНазначенияКлиент.ДатаСеанса() + 5 * 60 Тогда
			ТекстВопроса = НСтр("ru = 'Сейчас будет завершена работа всех активных пользователей.
				|Указано слишком большое время начала действия блокировки, до которого в приложение могут успеть войти другие пользователи.
				|Рекомендуется установить время начала на 5 минут относительно текущего времени.
				|
				|• Да, чтобы скорректировать время начала и продолжить (рекомендуется);
				|• Нет, чтобы продолжить без корректировки.'");
			ПоказатьВопрос(Новый ОписаниеОповещения("ПрименитьЗавершение1", ЭтотОбъект, Новый Структура("ЗаголовокВопроса, ТекстВопроса", ЗаголовокВопроса, ТекстВопроса)), ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена,,, ЗаголовокВопроса);
            Возврат;
		Иначе	
			ТекстВопроса = НСтр("ru = 'Сейчас будет завершена работа всех активных пользователей.
				|Продолжить?'");
			ПоказатьВопрос(Новый ОписаниеОповещения("ПрименитьЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ОКОтмена,,, ЗаголовокВопроса);
            Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ПрименитьФрагмент2();
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьЗавершение2(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ЗаголовокВопроса = ДополнительныеПараметры.ЗаголовокВопроса;
	ТекстВопроса = ДополнительныеПараметры.ТекстВопроса;
	
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Объект.НачалоДействияБлокировки = ОбщегоНазначенияКлиент.ДатаСеанса() + 5 * 60;
	ИначеЕсли Ответ <> КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ПрименитьФрагмент2();

КонецПроцедуры

&НаКлиенте
Процедура ПрименитьФрагмент2()
	
	ПрименитьФрагмент1();

КонецПроцедуры

&НаКлиенте
Процедура ПрименитьЗавершение1(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ЗаголовокВопроса = ДополнительныеПараметры.ЗаголовокВопроса;
	ТекстВопроса = ДополнительныеПараметры.ТекстВопроса;
	
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Объект.НачалоДействияБлокировки = ОбщегоНазначенияКлиент.ДатаСеанса() + 5 * 60;
	ИначеЕсли Ответ <> КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ПрименитьФрагмент1();

КонецПроцедуры

&НаКлиенте
Процедура ПрименитьФрагмент1()
	
	ПрименитьФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ПрименитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	ПрименитьФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ПрименитьФрагмент()
	
	Если Не УстановитьСнятьБлокировку() Тогда
		Возврат;	
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Блокировка работы пользователей'"),
	"e1cib/app/Обработка.БлокировкаРаботыПользователей",
	?(Объект.ВременноЗапретитьРаботуПользователей, НСтр("ru = 'Блокировка установлена.'"), НСтр("ru = 'Блокировка снята.'")), 
	БиблиотекаКартинок.Информация32);
	СоединенияИБКлиент.УстановитьОбработчикиОжиданияЗавершенияРаботыПользователей(
	Объект.ВременноЗапретитьРаботуПользователей);
	Если Объект.ВременноЗапретитьРаботуПользователей Тогда	
		ОбновитьСтраницуСостояния(ЭтотОбъект);
	Иначе
		ОбновитьСтраницуНастройки();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Остановить(Команда)
	
	Если Не ОтменитьБлокировку() Тогда
		Возврат;
	КонецЕсли;
	СоединенияИБКлиент.УстановитьОбработчикиОжиданияЗавершенияРаботыПользователей(Ложь);
	ПоказатьПредупреждение(Неопределено, НСтр("ru = Завершение работы активных пользователей отменено. 
		|Вход в программу новых пользователей оставлен заблокированным."));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ПроверитьПредусловияБлокировки()
	
	Возврат ПроверитьЗаполнение();

КонецФункции

&НаСервереБезКонтекста
Функция АктивныТолькоКлиентскиеПриложения(ИменаАктивныхСеансов)
	
	Результат = Истина;
	НазванияСоединенийИБ = "";
	НомерТекущегоСеанса = НомерСеансаИнформационнойБазы();
	Для каждого Сеанс Из ПолучитьСеансыИнформационнойБазы() Цикл
		Если Сеанс.НомерСеанса = НомерТекущегоСеанса Тогда
			Продолжить;
		КонецЕсли;
		Если Сеанс.ИмяПриложения <> "1CV8" И Сеанс.ИмяПриложения <> "1CV8C" И
			Сеанс.ИмяПриложения <> "WebClient" Тогда
			ИменаАктивныхСеансов = ИменаАктивныхСеансов + Символы.ПС + "• " + Сеанс;
			Результат = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция УстановитьСнятьБлокировку()
	
	Попытка
		РеквизитФормыВЗначение("Объект").ВыполнитьУстановку();
		Элементы.ГруппаОшибка.Видимость = Ложь;
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Завершение работы пользователей'"), 
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Если Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
			Элементы.ГруппаОшибка.Видимость = Истина;
			Элементы.ТекстОшибки.Заголовок = КраткоеОписаниеОшибки(ОписаниеОшибки());
		КонецЕсли;
		Возврат Ложь;
	КонецПопытки;
	НачальныйСтатусЗапретаРаботыПользователей = Объект.ВременноЗапретитьРаботуПользователей;
	КоличествоСеансов = ПолучитьСеансыИнформационнойБазы().Количество();
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ОтменитьБлокировку()
	
	Попытка
		РеквизитФормыВЗначение("Объект").ОтменитьБлокировку();
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Завершение работы пользователей'"), 
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Если Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
			Элементы.ГруппаОшибка.Видимость = Истина;
			Элементы.ТекстОшибки.Заголовок = КраткоеОписаниеОшибки(ОписаниеОшибки());
		КонецЕсли;
		Возврат Ложь;
	КонецПопытки;
	НачальныйСтатусЗапретаРаботыПользователей = Объект.ВременноЗапретитьРаботуПользователей;
	Элементы.ГруппаРежим.ТекущаяСтраница = Элементы.СтраницаНастройки;
	ОбновитьСтраницуНастройки();
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОбновитьСтраницуНастройки()
	
	Элементы.КомандаПрименить.Видимость = Истина;
	Элементы.КомандаПрименить.КнопкаПоУмолчанию = Истина;
	Элементы.КомандаОстановить.Видимость = Ложь;
	Элементы.КомандаПрименить.Заголовок = ?(Объект.ВременноЗапретитьРаботуПользователей,
		НСтр("ru='Снять блокировку'"), НСтр("ru='Установить блокировку'"));
	Элементы.ЗапретитьРаботуРегламентныхЗаданий.Заголовок = ?(Объект.ВременноЗапретитьРаботуПользователей,
		НСтр("ru='Оставить блокировку работы регламентных заданий'"), НСтр("ru='Также запретить работу регламентных заданий'"));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСтраницуСостояния(Форма)
	
	Форма.Элементы.КомандаОстановить.Видимость = Истина;
	Форма.Элементы.КомандаПрименить.Видимость = Ложь;
	Форма.Элементы.КомандаЗакрыть.КнопкаПоУмолчанию = Истина;
	ОбновитьСостояниеБлокировки(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСостояниеБлокировки(Форма)
	
	Форма.Элементы.Состояние.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Пожалуйста, подождите...
			|Работа пользователей завершается. Осталось активных сеансов: %1'"),
			Форма.КоличествоСеансов);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьПараметрыБлокировки(ТолькоПроверка = Ложь)
	Обработка = РеквизитФормыВЗначение("Объект");
	Попытка
		Обработка.ПолучитьПараметрыБлокировки();
		Элементы.ГруппаОшибка.Видимость = Ложь;
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Завершение работы пользователей'"), 
			УровеньЖурналаРегистрации.Ошибка,,, 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Если Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
			Элементы.ГруппаОшибка.Видимость = Истина;
			Элементы.ТекстОшибки.Заголовок = КраткоеОписаниеОшибки(ОписаниеОшибки());
		КонецЕсли;
	КонецПопытки;
	Если Не ТолькоПроверка Тогда
		ЗначениеВРеквизитФормы(Обработка, "Объект");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция КраткоеОписаниеОшибки(ОписаниеОшибки)
	ТекстОшибки = ОписаниеОшибки;
	Позиция = СтрНайти(ТекстОшибки, "}:");
	Если Позиция > 0 Тогда
		ТекстОшибки = СокрЛП(Сред(ТекстОшибки, Позиция + 2, СтрДлина(ТекстОшибки)));
	КонецЕсли;
	Возврат ТекстОшибки;
КонецФункции	