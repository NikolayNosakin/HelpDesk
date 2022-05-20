﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Напоминания пользователя".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Создаёт новое оповещение пользователя. Если по объекту уже есть оповещение - перезаписывает его.
Процедура ПодключитьНапоминание(ПараметрыОповещения, ОбновитьСрокНапоминания = Ложь) Экспорт
	
	НаборЗаписей = РегистрыСведений.НапоминанияПользователя.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(ПараметрыОповещения.Пользователь);
	НаборЗаписей.Отбор.Источник.Установить(ПараметрыОповещения.Источник);
	НаборЗаписей.Отбор.ВремяСобытия.Установить(ПараметрыОповещения.ВремяСобытия);
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		Если не ОбновитьСрокНапоминания Тогда
			НоваяЗапись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, ПараметрыОповещения);
		КонецЕсли;
	Иначе
		Для Каждого Запись Из НаборЗаписей Цикл
			ЗаполнитьЗначенияСвойств(Запись, ПараметрыОповещения,,?(ОбновитьСрокНапоминания,"","СрокНапоминания"));
		КонецЦикла;
	КонецЕсли;
	
	НаборЗаписей.Записать();
КонецПроцедуры

// Отключает оповещение, если оно есть. Если оповещение периодическое, подключает его на ближайшую дату по расписанию.
Процедура ОтключитьНапоминание(ПараметрыОповещения, ПодключатьПоРасписанию = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	// ищем существующую запись
	Запрос = Новый Запрос;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	НапоминанияПользователя.Пользователь,
	|	НапоминанияПользователя.ВремяСобытия,
	|	НапоминанияПользователя.Источник,
	|	НапоминанияПользователя.СрокНапоминания,
	|	НапоминанияПользователя.Описание,
	|	НапоминанияПользователя.СпособУстановкиВремениНапоминания,
	|	НапоминанияПользователя.Расписание
	|ИЗ
	|	РегистрСведений.НапоминанияПользователя КАК НапоминанияПользователя
	|ГДЕ
	|	НапоминанияПользователя.Пользователь = &Пользователь
	|	И НапоминанияПользователя.ВремяСобытия = &ВремяСобытия
	|	И НапоминанияПользователя.Источник = &Источник";
	
	Запрос.УстановитьПараметр("Пользователь", ПараметрыОповещения.Пользователь);
	Запрос.УстановитьПараметр("ВремяСобытия", ПараметрыОповещения.ВремяСобытия);
	Запрос.УстановитьПараметр("Источник", ПараметрыОповещения.Источник);
	
	Запрос.Текст = ТекстЗапроса;
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Оповещение = Неопределено;
	Если РезультатЗапроса.Количество() > 0 Тогда
		Оповещение = РезультатЗапроса[0];
	КонецЕсли;
	
	// удаляем существующую запись
	НаборЗаписей = РегистрыСведений.НапоминанияПользователя.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(ПараметрыОповещения.Пользователь);
	НаборЗаписей.Отбор.Источник.Установить(ПараметрыОповещения.Источник);
	НаборЗаписей.Отбор.ВремяСобытия.Установить(ПараметрыОповещения.ВремяСобытия);
	
	НаборЗаписей.Очистить();
	НаборЗаписей.Записать();
	
	СледующаяДатаПоРасписанию = Неопределено;
	ОпределенаСледующаяДатаПоРасписанию = Ложь;
	
	// подключаем следующее оповещение по расписанию
	Если ПодключатьПоРасписанию и Оповещение <> Неопределено Тогда
		Если Оповещение.СпособУстановкиВремениНапоминания = ПредопределенноеЗначение("Перечисление.СпособыУстановкиВремениНапоминания.Периодически") Тогда
			Расписание = Оповещение.Расписание.Получить();
			Если Расписание.ПериодПовтораДней > 0 Тогда
				СледующаяДатаПоРасписанию = НапоминанияПользователяСервер.ПолучитьБлижайшуюДатуСобытияПоРасписанию(Расписание);
			КонецЕсли;
			ОпределенаСледующаяДатаПоРасписанию = СледующаяДатаПоРасписанию <> Неопределено;
		КонецЕсли;
		
		Если ОпределенаСледующаяДатаПоРасписанию Тогда
			Оповещение.ВремяСобытия = СледующаяДатаПоРасписанию;
			Оповещение.СрокНапоминания = Оповещение.ВремяСобытия;
			ПодключитьНапоминание(Оповещение);				
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Выполняет запрос по напоминаниям для текущего пользователя на момент времени ТекущаяДатаСеанса() + 30минут.
// Момент времени смещён от текущего для использования функции из модуля с повторным использованием
// возвращаемых значений.
// При обработке результата выполнения функции необходимо учитывать эту особенность.
//
// Параметры
//	Нет
//
// Возвращаемое значение
//  Массив - таблица значений, сконвертированная в массив из структур, содержащих данные строк таблицы.
Функция ПолучитьНапоминанияТекущегоПользователя() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Напоминания.Пользователь КАК Пользователь,
	|	Напоминания.ВремяСобытия КАК ВремяСобытия,
	|	Напоминания.Источник КАК Источник,
	|	Напоминания.СрокНапоминания КАК СрокНапоминания,
	|	Напоминания.Описание КАК Описание,
	|	2 КАК ИндексКартинки
	|ИЗ
	|	РегистрСведений.НапоминанияПользователя КАК Напоминания
	|ГДЕ
	|	Напоминания.СрокНапоминания <= &ТекущаяДата
	|	И Напоминания.Пользователь = &Пользователь
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВремяСобытия";
	
	
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаСеанса() + 30*60);// +30 минут для кэша
	Запрос.УстановитьПараметр("Пользователь", Пользователи.ТекущийПользователь());
	
	
	Результат = НапоминанияПользователяСервер.ПолучитьМассивСтруктурИзТаблицы(Запрос.Выполнить().Выгрузить());
	
	Возврат Результат;
	
КонецФункции
