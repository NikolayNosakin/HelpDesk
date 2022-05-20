﻿// Устанавливает признак Прочтено для письма.
//
Процедура УстановитьСвойствоПрочтено(Письмо, Прочтено, Знач Пользователь = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Запись = РегистрыСведений.СведенияОПисьмах.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Письмо = Письмо;
	Запись.Прочитать();
	
	Запись.Пользователь = Пользователь;
	Запись.Письмо = Письмо;
	Запись.Прочтено = Прочтено;
	Запись.Записать(Истина);
	
КонецПроцедуры

// Возвращает признак Прочтено для письма.
//
Функция ПолучитьСвойствоПрочтено(Письмо, Знач Пользователь = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Запись = РегистрыСведений.СведенияОПисьмах.СоздатьМенеджерЗаписи();
	Запись.Пользователь = Пользователь;
	Запись.Письмо = Письмо;
	Запись.Прочитать();
	
	Если Не Запись.Выбран() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Запись.Прочтено;
	
КонецФункции
