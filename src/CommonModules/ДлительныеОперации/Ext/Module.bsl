﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Поддержка работы длительных серверных операций в веб-клиенте.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Запускает выполнение процедуры в фоновом задании.
// 
// Параметры:
//  ИдентификаторФормы     - УникальныйИдентификатор - идентфикатор формы, 
//                           из которой выполняется запуск длительной операции. 
//  ИмяЭкспортнойПроцедуры - Строка - имя экспортной процедуры, 
//                           которую необходимо выполнить в фоне.
//  Параметры              - Структура - все необходимые параметры для 
//                           выполнения процедуры ИмяЭкспортнойПроцедуры.
//  НаименованиеЗадания    - Строка - наименование фонового задания. 
//                           Если не задано, то будет равно ИмяЭкспортнойПроцедуры. 
//  ИспользоватьДополнительноеВременноеХранилище – Булево – признак использования
//                           дополнительного временного хранилища для передачи данных
//                           в родительский сеанс из фонового задания. По умолчанию – Ложь.
//
// Возвращаемое значение:
//  Структура              - Возвращает свойства: 
//                             - АдресХранилища - адрес временного хранилища, в которое будет
//                          	 помещен результат работы задания;
//                             - АдресХранилищаДополнительный - адрес дополнительного временного хранилища,
//                               в которое будет помещен результат работы задания (доступно только если 
//                               установлен параметр ИспользоватьДополнительноеВременноеХранилище);
//                             - ИдентификаторЗадания - уникальный идентификатор запущенного
//                               фонового задания;
//                             - ЗаданиеВыполнено - Истина если задание было успешно выполнено 
//                               за время вызова функции.
// 
Функция ЗапуститьВыполнениеВФоне(Знач ИдентификаторФормы, Знач ИмяЭкспортнойПроцедуры, 
	Знач Параметры, Знач НаименованиеЗадания = "", ИспользоватьДополнительноеВременноеХранилище = Ложь) Экспорт
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, ИдентификаторФормы);
	
	Если Не ЗначениеЗаполнено(НаименованиеЗадания) Тогда
		НаименованиеЗадания = ИмяЭкспортнойПроцедуры;
	КонецЕсли;
	
	ПараметрыЭкспортнойПроцедуры = Новый Массив;
	ПараметрыЭкспортнойПроцедуры.Добавить(Параметры);
	ПараметрыЭкспортнойПроцедуры.Добавить(АдресХранилища);
	
	Если ИспользоватьДополнительноеВременноеХранилище Тогда
		АдресХранилищаДополнительный = ПоместитьВоВременноеХранилище(Неопределено, ИдентификаторФормы);
		ПараметрыЭкспортнойПроцедуры.Добавить(АдресХранилищаДополнительный);
	КонецЕсли;
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(ИмяЭкспортнойПроцедуры);
	ПараметрыЗадания.Добавить(ПараметрыЭкспортнойПроцедуры);

	Если ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая тогда
		ВремяОжидания = 4;
	Иначе
		ВремяОжидания = 2;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей() Тогда
		
		Если ОбщегоНазначения.ИспользованиеРазделителяСеанса() Тогда
			ПараметрыЗадания.Добавить(ОбщегоНазначения.ЗначениеРазделителяСеанса());	
		Иначе
			ПараметрыЗадания.Добавить(Неопределено);
		КонецЕсли;
		
		ТекущееЗначение = ОбщегоНазначения.ИспользованиеРазделителяСеанса();
		ОбщегоНазначения.УстановитьРазделениеСеанса(Ложь);
		
		Задание = ФоновыеЗадания.Выполнить("ОбщегоНазначения.ВыполнитьБезопасно", ПараметрыЗадания,, НаименованиеЗадания);
		Попытка
			Задание.ОжидатьЗавершения(ВремяОжидания);
		Исключение
			// Специальная обработка не требуется, возможно исключение вызвано истечением времени ожидания.
		КонецПопытки;
		
		ОбщегоНазначения.УстановитьРазделениеСеанса(ТекущееЗначение);
	Иначе
		ПараметрыЗадания.Добавить(Неопределено);
		Задание = ФоновыеЗадания.Выполнить("ОбщегоНазначения.ВыполнитьБезопасно", ПараметрыЗадания,, НаименованиеЗадания);
		Попытка
			Задание.ОжидатьЗавершения(ВремяОжидания);
		Исключение		
			// Специальная обработка не требуется, возможно исключение вызвано истечением времени ожидания.
		КонецПопытки;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("АдресХранилища",       АдресХранилища);
	Результат.Вставить("ЗаданиеВыполнено",     ЗаданиеВыполнено(Задание.УникальныйИдентификатор));
	Результат.Вставить("ИдентификаторЗадания", Задание.УникальныйИдентификатор);
	
	Если ИспользоватьДополнительноеВременноеХранилище Тогда
		Результат.Вставить("АдресХранилищаДополнительный", АдресХранилищаДополнительный);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Отменяет выполение фонового задания по переданному идентификатору.
// 
// Параметры:
//  ИдентификаторЗадания - УникальныйИдентификатор - идентификатор фонового задания. 
// 
Процедура ОтменитьВыполнениеЗадания(Знач ИдентификаторЗадания) Экспорт 
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		Возврат;
	КонецЕсли;
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	Если Задание = Неопределено
		ИЛИ Задание.Состояние <> СостояниеФоновогоЗадания.Активно Тогда
		
		Возврат;
	КонецЕсли;
	
	Попытка
		Задание.Отменить();
	Исключение
		// Возможно задание как раз в этот момент закончилось и ошибки нет
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Длительные операции.Отмена выполнения фонового задания'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

// Проверяет состояние фонового задания по переданному идентификатору.
// 
// Параметры:
//  ИдентификаторЗадания - УникальныйИдентификатор - идентификатор фонового задания. 
//
// Возвращаемое значение:
//  Булево              - возвращает Истина, если задание успешно выполнено,
//                        Ложь - если выполняется. В иных случаях вызывается исключение.
// 
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания) Экспорт
	
	Задание = НайтиЗаданиеПоИдентификатору(ИдентификаторЗадания);
	
	Если Задание <> Неопределено
		И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОперацияНеВыполнена = Истина;
	ПоказатьПолныйТекстОшибки = Ложь;
	Если Задание = Неопределено Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Длительные операции.Фоновое задание не найдено'"),
			УровеньЖурналаРегистрации.Ошибка,,, Строка(ИдентификаторЗадания));
	Иначе	
		Если Задание.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
			ОшибкаЗадания = Задание.ИнформацияОбОшибке;
			Если ОшибкаЗадания <> Неопределено Тогда
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Длительные операции.Фоновое задание завершено аварийно'"),
					УровеньЖурналаРегистрации.Ошибка,,,
					ПодробноеПредставлениеОшибки(Задание.ИнформацияОбОшибке));
				ПоказатьПолныйТекстОшибки = Истина;	
			Иначе
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Длительные операции.Фоновое задание завершено аварийно'"),
					УровеньЖурналаРегистрации.Ошибка,,,
					НСтр("ru = 'Задание завершилось с неизвестной ошибкой.'"));
			КонецЕсли;
		ИначеЕсли Задание.Состояние = СостояниеФоновогоЗадания.Отменено Тогда
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Длительные операции.Фоновое задание отменено администратором'"),
				УровеньЖурналаРегистрации.Ошибка,,,
				НСтр("ru = 'Задание завершилось с неизвестной ошибкой.'"));
		Иначе
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ПоказатьПолныйТекстОшибки Тогда
		ТекстОшибки = КраткоеПредставлениеОшибки(ПолучитьИнформациюОбОшибке(Задание.ИнформацияОбОшибке));
		ВызватьИсключение(ТекстОшибки);
	ИначеЕсли ОперацияНеВыполнена Тогда
		ВызватьИсключение(НСтр("ru = 'Не удалось выполнить данную операцию. 
                                |Подробности см. в Журнале регистрации.'"));
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция НайтиЗаданиеПоИдентификатору(Знач ИдентификаторЗадания)
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей() Тогда
		
		ТекущееЗначение = ОбщегоНазначения.ИспользованиеРазделителяСеанса();
		
		ОбщегоНазначения.УстановитьРазделениеСеанса(Ложь);
		Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
		ОбщегоНазначения.УстановитьРазделениеСеанса(ТекущееЗначение);
	Иначе
		Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	КонецЕсли;
	
	Возврат Задание;
	
КонецФункции

Функция ПолучитьИнформациюОбОшибке(ИнформацияОбОшибке)
	
	Результат = ИнформацияОбОшибке;
	Если ИнформацияОбОшибке <> Неопределено Тогда
		Если ИнформацияОбОшибке.Причина <> Неопределено Тогда
			Результат = ПолучитьИнформациюОбОшибке(ИнформацияОбОшибке.Причина);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

