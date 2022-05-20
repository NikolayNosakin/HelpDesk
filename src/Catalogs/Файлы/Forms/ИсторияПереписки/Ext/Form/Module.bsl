﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Предмет = Параметры.Предмет;
	
	ЗаполнитьДеревоПереписки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЭлементыДерева = ДеревоПисем.ПолучитьЭлементы();
	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		Элементы.ДеревоПисем.Развернуть(ЭлементДерева.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПереписки()
	
	Дерево = РеквизитФормыВЗначение("ДеревоПисем");
	Дерево.Строки.Очистить();
	ВыведенныеПисьма = Новый Массив;
	ДобавитьПисьмоВДерево(Дерево.Строки, Предмет, ВыведенныеПисьма);
	ЗначениеВРеквизитФормы(Дерево, "ДеревоПисем");
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПисьмоВДерево(СтрокиДерева, Письмо, ВыведенныеПисьма)
	
	Если ВыведенныеПисьма.Найти(Письмо) <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	ВыведенныеПисьма.Добавить(Письмо);
	
	СтрокаДерева = СтрокиДерева.Добавить();
	СтрокаДерева.Ссылка = Письмо;
	СтрокаДерева.ИндексКартинки = ПолучитьИндексКартинки(Письмо);
	Если ДелопроизводствоКлиентСервер.ЭтоФайл(Письмо) Тогда
		СтрокаДерева.Заголовок = ПолучитьПредставлениеФайла(Письмо);
		СтрокаДерева.Адресаты = "";
		СтрокаДерева.Дата = Письмо.ДатаСоздания;
		СтрокаДерева.ДатаСоздания = Письмо.ДатаСоздания;
	ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоВходящийДокумент(Письмо) Тогда
		СтрокаДерева.Заголовок = ПолучитьПредставлениеДокумента(Письмо);
		СтрокаДерева.Адресаты = "";
		СтрокаДерева.Дата = Письмо.ДатаРегистрации;
		СтрокаДерева.ДатаСоздания = Письмо.ДатаСоздания;
	ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоИсходящийДокумент(Письмо) Тогда
		СтрокаДерева.Заголовок = ПолучитьПредставлениеДокумента(Письмо);
		СтрокаДерева.Адресаты = "";
		СтрокаДерева.Дата = Письмо.ДатаРегистрации;
		СтрокаДерева.ДатаСоздания = Письмо.ДатаСоздания;
	ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоВходящееПисьмо(Письмо) Тогда
		СтрокаДерева.Заголовок = ВстроеннаяПочтаСервер.ПолучитьПредставлениеПисьма(Письмо);
		СтрокаДерева.Адресаты = Письмо.ОтправительОтображаемоеИмя;
		СтрокаДерева.Дата = Письмо.Дата;
		СтрокаДерева.ДатаСоздания = Письмо.Дата;
	ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоИсходящееПисьмо(Письмо) Тогда
		СтрокаДерева.Заголовок = ВстроеннаяПочтаСервер.ПолучитьПредставлениеПисьма(Письмо);
		СтрокаДерева.Адресаты = Письмо.ПолучателиПисьмаСтрокой;
		СтрокаДерева.Дата = Письмо.Дата;
		СтрокаДерева.ДатаСоздания = Письмо.Дата;
	КонецЕсли;
	
	ЗаполнитьПодчиненныеДокументы(СтрокаДерева.Строки, Письмо, ВыведенныеПисьма);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПредставлениеДокумента(Документ)
	
	Возврат Документ.Заголовок + " " + ВКавычках(Документ.Метаданные().ПредставлениеОбъекта, "(", ")")
	
КонецФункции

&НаСервере
Функция ПолучитьПредставлениеФайла(Документ)
	
	Возврат Документ.ПолноеНаименование + " " + ВКавычках(Документ.Метаданные().ПредставлениеОбъекта, "(", ")")
	
КонецФункции


&НаСервере
Процедура ЗаполнитьПодчиненныеДокументы(СтрокиДерева, Родитель, ВыведенныеПисьма)
	
	ПодчиненныеПисьма = ВстроеннаяПочтаСервер.ПолучитьПодчиненныеПисьма(Родитель);
	Для каждого ПодчиненноеПисьмо Из ПодчиненныеПисьма Цикл
		ДобавитьПисьмоВДерево(СтрокиДерева, ПодчиненноеПисьмо, ВыведенныеПисьма);
	КонецЦикла;
	
	КорневыеПисьмаПоПредмету = ВстроеннаяПочтаСервер.ПолучитьКорневыеПисьмаПоПредмету(Родитель);
	Для каждого КорневоеПисьмо Из КорневыеПисьмаПоПредмету Цикл
		ДобавитьПисьмоВДерево(СтрокиДерева, КорневоеПисьмо, ВыведенныеПисьма);
	КонецЦикла;
	
	СтрокиДерева.Сортировать("ДатаСоздания");
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИндексКартинки(Документ)
	
	Если ДелопроизводствоКлиентСервер.ЭтоФайл(Документ) Тогда
		Возврат 2;
	ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоВходящийДокумент(Документ) Тогда
		Возврат 0;
	ИначеЕсли ДелопроизводствоКлиентСервер.ЭтоИсходящийДокумент(Документ) Тогда
		Если Документ.Получатели.Найти(Истина, "Отправлен") <> Неопределено Тогда
			Возврат 1;
		Иначе
			Возврат 3;
		КонецЕсли;
	ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоВходящееПисьмо(Документ) Тогда
		Возврат 0;
	ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоИсходящееПисьмо(Документ) Тогда
		Если ЗначениеЗаполнено(Документ.ДатаОТправки) Тогда
			Возврат 1;
		Иначе
			Возврат 3;
		КонецЕсли;
	Иначе
		ВызватьИсключение НСтр("ru = 'Передан некорректный вид документа'");
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ДеревоПисемВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ДеревоПисем.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		ПоказатьЗначение(Неопределено, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПисемПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.ДеревоПисем.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		ПоказатьЗначение(Неопределено, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры
