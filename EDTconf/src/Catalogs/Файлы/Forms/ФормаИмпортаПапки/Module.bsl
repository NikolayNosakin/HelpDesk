
// Обработка события ПриОткрытии формы
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВыборКаталогов = Истина;
	ХранитьВерсии = Истина;
	
КонецПроцедуры

// Обработка нажатия на кнопку Импорт
//
&НаКлиенте
Процедура ИмпортВыполнить()
	
	Если ПустаяСтрока(Каталог) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не выбран каталог для импорта.'"), , "Каталог");
		Возврат;
		
	КонецЕсли;
	
	Если ПапкаДляДобавления.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Укажите папку.'"), , "ПапкаДляДобавления");
		Возврат;
	КонецЕсли;
	
	ВыбранныеФайлы = Новый СписокЗначений;
	ВыбранныеФайлы.Добавить(Каталог);
	
	ПсевдоФайловаяСистема = Новый Соответствие; // соответствие путь к директории - файлы и папки в ней 
	ДобавленныеФайлы = Новый Массив;
	
	ПапкаДляДобавленияТекущая = РаботаСФайламиКлиент.ИмпортФайловВыполнить(
		ПапкаДляДобавления, 
		ВыбранныеФайлы, 
		Описание, 
		ХранитьВерсии, 
		УдалятьФайлыПослеДобавления, 
		Истина,
		УникальныйИдентификатор,
		ПсевдоФайловаяСистема,
		ДобавленныеФайлы,
		Ложь,
		КодировкаТекстаФайла);
		
	Закрыть();
	
	Оповестить("ИмпортКаталоговЗавершен", Новый Структура, ПапкаДляДобавленияТекущая);
	
КонецПроцедуры

// Обработка события НачалоВыбора у поля Папка
//
&НаКлиенте
Процедура ВыбранныйКаталогНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	#Если НЕ ВебКлиент Тогда
		Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
		
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		
		ДиалогОткрытияФайла.Каталог = Каталог;
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
		ДиалогОткрытияФайла.Фильтр = Фильтр;
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите каталог'");
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			
			Если ВыборКаталогов = Истина Тогда 
				
				Каталог = ДиалогОткрытияФайла.Каталог;
				
			КонецЕсли;
			
		КонецЕсли;
			
		СтандартнаяОбработка = Ложь;
	#КонецЕсли
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("КаталогНаДиске") Тогда 	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Данная обработка вызывается из других процедур конфигурации. Вручную ее вызывать запрещено.'")); 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Параметры.КаталогНаДиске <> Неопределено Тогда
		Каталог = Параметры.КаталогНаДиске;
	КонецЕсли;
	
	Если Параметры.ПапкаДляДобавления <> Неопределено Тогда
		ПапкаДляДобавления = Параметры.ПапкаДляДобавления;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеКомандыКодировки(Представление)
	
	Команды.ВыбратьКодировку.Заголовок = Представление;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодировку(Команда)
	
	ПараметрыФормы = Новый Структура("ТекущаяКодировка", КодировкаТекстаФайла);
	КодВозврата = Неопределено;

	ОткрытьФорму("Справочник.Файлы.Форма.ВыборКодировки", ПараметрыФормы,,,,, Новый ОписаниеОповещения("ВыбратьКодировкуЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодировкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КодВозврата = Результат;
	
	Если ТипЗнч(КодВозврата) = Тип("Структура") Тогда
		
		КодировкаТекстаФайла = КодВозврата.Значение;
		КодировкаПредставление = КодВозврата.Представление;
		УстановитьПредставлениеКомандыКодировки(КодировкаПредставление);
		
	КонецЕсли;
	
КонецПроцедуры


