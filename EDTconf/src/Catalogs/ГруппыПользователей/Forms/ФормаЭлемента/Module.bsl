////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка = Справочники.ГруппыПользователей.ПустаяСсылка()
	   И Объект.Родитель = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		
		Объект.Родитель = Справочники.ГруппыПользователей.ПустаяСсылка();
	КонецЕсли;
	
	Если Объект.Ссылка = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		Элементы.Наименование.ТолькоПросмотр = Истина;
		Элементы.Родитель.ТолькоПросмотр     = Истина;
		Элементы.СоставПодобрать.Доступность = Ложь;
		Элементы.Состав.ТолькоПросмотр       = Истина;
		Элементы.Комментарий.ТолькоПросмотр  = Истина;
	КонецЕсли;
	
	// Педаховский Юрий 11,02,2014 начало

	//АбисСофт-Кострицын Олег-Старт  17 января 2014 г.
	//Если Не Объект.Ссылка.Пустая() Тогда
		//РолиВГруппе.Параметры.УстановитьЗначениеПараметра("ГруппаПользователей", Объект.Ссылка);
	//КонецЕсли;
	//АбисСофт-Кострицын Олег-финиш  17 января 2014 г.
	
	УстановитьПараметрыДинамическогоСписка();

	// Педаховский Юрий 11,02,2014 конец

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ГруппыПользователей", Новый Структура, Объект.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура РодительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ВыборРодителя");
	
	ОткрытьФорму("Справочник.ГруппыПользователей.ФормаВыбора", ПараметрыФормы, Элементы.Родитель);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Состав

&НаКлиенте
Процедура СоставОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		
		Для каждого Значение Из ВыбранноеЗначение Цикл
			ОбработкаВыбораПользователя(Значение);
		КонецЦикла;
	Иначе
		ОбработкаВыбораПользователя(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПодобратьПользователей(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормы, Элементы.Состав);

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ОбработкаВыбораПользователя(ВыбранноеЗначение)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи") Тогда
		
		Отбор = Новый Структура("Пользователь", ВыбранноеЗначение);
		Если Объект.Состав.НайтиСтроки(Отбор).Количество() = 0 Тогда
			
			Объект.Состав.Добавить().Пользователь = ВыбранноеЗначение;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Педаховский Юрий 11,02,2014 начало
&НаКлиенте
Процедура РолиВГруппеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Не Копирование;
	
	Если НеобходимоЗаписатьОбъект() Тогда
		
		Записать();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка)
		И Не Копирование Тогда
		
		ФормаЗаписи = ПолучитьФорму("РегистрСведений.СоответствиеРолейВГруппеПользователей.ФормаЗаписи", , Элемент);
		ФормаЗаписи.Запись.ГруппаПользователей = Объект.Ссылка;
		ФормаЗаписи.Открыть();
	КонецЕсли;
	
	УстановитьПараметрыДинамическогоСписка();
КонецПроцедуры

&НаКлиенте
Функция НеобходимоЗаписатьОбъект()
	
	ТекстВопроса = "Перед созданием записи группу нужно записать.Продолжить?";
	
	Результат = КодВозвратаДиалога.Да;

	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Результат = Вопрос(ТекстВопроса,РежимДиалогаВопрос.ДаНет);			
	КонецЕсли;
	
	Возврат Результат = КодВозвратаДиалога.Да;

КонецФункции

&НаСервере
Процедура УстановитьПараметрыДинамическогоСписка()
	
	ЗначенеиеГруппаПользователей = РолиВГруппе.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ГруппаПользователей")); 
	Если ЗначенеиеГруппаПользователей = Неопределено 
		ИЛИ (ЗначенеиеГруппаПользователей.Значение <> Объект.Ссылка)
		ИЛИ (Не ЗначенеиеГруппаПользователей.Использование)Тогда
		
		РолиВГруппе.Параметры.УстановитьЗначениеПараметра("ГруппаПользователей", Объект.Ссылка);
	КонецЕсли;
КонецПроцедуры

// Педаховский Юрий 11,02,2014 конец
