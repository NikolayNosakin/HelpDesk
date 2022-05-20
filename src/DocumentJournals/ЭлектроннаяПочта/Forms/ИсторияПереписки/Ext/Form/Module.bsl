﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущееПисьмо = Параметры.ТекущееПисьмо;
	ЗаполнитьДеревоПереписки();
	
	ПоложениеОбластиЧтения = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ЭтотОбъект.ИмяФормы, 
		"ПоложениеОбластиЧтения", "Снизу");
	ОбновитьПоложениеОбластиЧтенияСервер();
	
	ЧислоПисемВПереписке = ВстроеннаяПочтаСервер.ПолучитьКоличествоПисемВПереписке(ТекущееПисьмо);
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='История переписки (писем: %1)'"), Формат(ЧислоПисемВПереписке, "ЧН=0"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗагруженыПисьма" Тогда
		ОбновитьТекущийСписок();
	КонецЕсли;
	
	Если ИмяСобытия = "ПрочтеноПисьмо" Тогда
		ОбновитьТекущийСписок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РазвернутьДеревоПисем();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;	
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ЭтотОбъект.ИмяФормы, "ПоложениеОбластиЧтения", ПоложениеОбластиЧтения);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// КОМАНДЫ ФОРМЫ 

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьДеревоПереписки();
	РазвернутьДеревоПисем();
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьДеревоПисем()
	
	// Развернем узлы верхнего уровня
	Для Каждого СтрокаДерева Из ДеревоПисем.ПолучитьЭлементы() Цикл
		Элементы.ДеревоПисем.Развернуть(СтрокаДерева.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ 

&НаКлиенте
Процедура ДеревоПисемВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(Неопределено, Элементы.ДеревоПисем.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПисемПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ПоказатьЗначение(Неопределено, Элементы.ДеревоПисем.ТекущиеДанные.Ссылка);
	
КонецПроцедуры


&НаКлиенте
Процедура ДеревоПисемПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка", 0.5, Истина);
	
	ТекущиеДанные = Элементы.ДеревоПисем.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		УстановитьДоступностьКоманд(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка", 0.5, Истина);
	
	ТекущиеДанные = Элементы.ДеревоПисем.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		УстановитьДоступностьКоманд(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()
	
	Если ПоложениеОбластиЧтения <> "Отключена" Тогда
		
		Если Элементы.ДеревоПисем.ТекущаяСтрока = Неопределено
			Или Элементы.ДеревоПисем.ТекущиеДанные = Неопределено
			Или ТипЗнч(Элементы.ДеревоПисем.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Предпросмотр = ПолучитьПустойТекстHTML();
			Возврат;
		КонецЕсли;
		
		Если ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(Элементы.ДеревоПисем.ТекущиеДанные.Ссылка) Тогда
			Предпросмотр = ВстроеннаяПочтаСервер.СформироватьТекстHTMLДляПисьма(
				Элементы.ДеревоПисем.ТекущиеДанные.Ссылка,
				УникальныйИдентификатор);
		Иначе
			Предпросмотр = ПолучитьПустойТекстHTML();
		КонецЕсли;
		
		ОбработатьТекстHTMLСервер(Предпросмотр);
		
		Если ТаблицаВложений.Количество()<>0 Тогда
			РаботаСHTML.ПередатьОбъектыСтраницыНаКлиента(Предпросмотр,ТаблицаВложений);
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПустойТекстHTML()
	
	Возврат "<html><body></body></html>";
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступностьКоманд(ТекущиеДанные)
	
	ЭтоВходящееПисьмо = ТекущиеДанные.Свойство("Ссылка")
		И ВстроеннаяПочтаКлиентСервер.ЭтоВходящееПисьмо(ТекущиеДанные.Ссылка);
	ЭтоИсходящееПисьмо = ТекущиеДанные.Свойство("Ссылка")
		И ВстроеннаяПочтаКлиентСервер.ЭтоИсходящееПисьмо(ТекущиеДанные.Ссылка);
	
	Элементы.Ответить.Доступность = ЭтоВходящееПисьмо;
	Элементы.ОтветитьВсем.Доступность = ЭтоВходящееПисьмо;
	Элементы.Переслать.Доступность = ЭтоВходящееПисьмо Или ЭтоИсходящееПисьмо;
	
	Элементы.ДеревоПисемКонтекстноеМенюОтветить.Доступность = ЭтоВходящееПисьмо;
	Элементы.ДеревоПисемКонтекстноеМенюПереслать.Доступность = ЭтоВходящееПисьмо Или ЭтоИсходящееПисьмо;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Процедура ОбновитьТекущийСписок()
	
	Элементы.ДеревоПисем.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура Ответить(Команда)
	
	ТекущиеДанные = ПолучитьТекущиеДанные();
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Не выбрано письмо.'"));
		Возврат;
	КонецЕсли;
	
	ВстроеннаяПочтаКлиент.ОтветитьНаПисьмо(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветитьВсем(Команда)
	
	ТекущиеДанные = ПолучитьТекущиеДанные();
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Не выбрано письмо.'"));
		Возврат;
	КонецЕсли;
	
	ВстроеннаяПочтаКлиент.ОтветитьВсемНаПисьмо(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Переслать(Команда)
	
	ТекущиеДанные = ПолучитьТекущиеДанные();
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Не выбрано письмо.'"));
		Возврат;
	КонецЕсли;
	
	ВстроеннаяПочтаКлиент.ПереслатьПисьмо(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьТекущиеДанные()
	
	Возврат Элементы.ДеревоПисем.ТекущиеДанные;
	
КонецФункции

///////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

&НаСервере
Процедура ЗаполнитьДеревоПереписки()
	
	ДеревоПисем.ПолучитьЭлементы().Очистить();
	КорневоеПисьмо = ВстроеннаяПочтаСервер.ПолучитьКорневоеПисьмо(ТекущееПисьмо);
	
	КорневойУровень = Истина;
	ЗаполнитьУзелДереваПереписки(ДеревоПисем.ПолучитьЭлементы(), КорневоеПисьмо, КорневойУровень);
	
	Индекс = -1;
	НайтиВДеревеПоСсылке(ДеревоПисем.ПолучитьЭлементы(), ТекущееПисьмо, Индекс);
	
	Если Индекс > -1 Тогда
		Элементы.ДеревоПисем.ТекущаяСтрока = Индекс;
	КонецЕсли;
	
КонецПроцедуры

Процедура НайтиВДеревеПоСсылке(КоллекцияЭлементовОдногоУровня, ИскомаяСсылка, Индекс)
	
	Если ТипЗнч(Индекс) = Тип("Число") И Индекс > -1 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаДерева Из КоллекцияЭлементовОдногоУровня Цикл
		
		Если СтрокаДерева.Ссылка = ИскомаяСсылка Тогда
			Индекс = СтрокаДерева.ПолучитьИдентификатор();
		Иначе
			НайтиВДеревеПоСсылке(СтрокаДерева.ПолучитьЭлементы(), ИскомаяСсылка, Индекс);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьУзелДереваПереписки(ЭлементыДерева, ПисьмоРодитель, Знач КорневойУровень)
	
	СтрокаКорня = ЭлементыДерева.Добавить();
	
	Если ВстроеннаяПочтаКлиентСервер.ЭтоВходящееПисьмо(ПисьмоРодитель) Тогда
		
		РеквизитыПисьма = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(
			ПисьмоРодитель,
			"Дата, ПолучателиПисьмаСтрокой, ОтправительОтображаемоеИмя, ОтправительАдрес, ОтправительКонтакт, Тема, ЕстьВложения, Размер, Важность");
		СтрокаКорня.Ссылка = ПисьмоРодитель;
		СтрокаКорня.Дата = РеквизитыПисьма.Дата;
		
		СтрокаКорня.Кому = РеквизитыПисьма.ПолучателиПисьмаСтрокой;
		СтрокаКорня.ОтКого = ВстроеннаяПочтаСервер.ПолучитьПредставлениеАдресата(
			РеквизитыПисьма.ОтправительКонтакт,
			РеквизитыПисьма.ОтправительОтображаемоеИмя,
			РеквизитыПисьма.ОтправительАдрес);
		
		СтрокаКорня.Тема = РеквизитыПисьма.Тема;
		
		Если РеквизитыПисьма.Важность = Перечисления.ВажностьПисем.Высокая Тогда
			СтрокаКорня.ВажностьНомерКартинки = 2;
		ИначеЕсли РеквизитыПисьма.Важность = Перечисления.ВажностьПисем.Низкая ТОгда
			СтрокаКорня.ВажностьНомерКартинки = 0;
		Иначе
			СтрокаКорня.ВажностьНомерКартинки = 1;
		КонецЕсли;
		
		СтрокаКорня.Размер = РеквизитыПисьма.Размер / 1024;
		СтрокаКорня.ЕстьВложения = РеквизитыПисьма.ЕстьВложения;
		СтрокаКорня.НомерКартинки = 0;
		СтрокаКорня.ЭтоТекущаяЗадача = (ПисьмоРодитель = ТекущееПисьмо);
		СтрокаКорня.Вид = ?(ВстроеннаяПочтаКлиентСервер.ЭтоВходящееПисьмо(ПисьмоРодитель), 0, 1);
		
	ИначеЕсли ВстроеннаяПочтаКлиентСервер.ЭтоИсходящееПисьмо(ПисьмоРодитель) Тогда
		
		РеквизитыПисьма = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(
			ПисьмоРодитель,
			"Дата, ПолучателиПисьмаСтрокой, Тема, ЕстьВложения, Размер, Важность, УчетнаяЗапись");
		СтрокаКорня.Ссылка = ПисьмоРодитель;
		СтрокаКорня.Дата = РеквизитыПисьма.Дата;
		
		СтрокаКорня.Кому = РеквизитыПисьма.ПолучателиПисьмаСтрокой;
		СтрокаКорня.ОтКого = Справочники.УчетныеЗаписиЭлектроннойПочты.ПолучитьПредставлениеАдреса(РеквизитыПисьма.УчетнаяЗапись);
		
		СтрокаКорня.Тема = РеквизитыПисьма.Тема;
		
		Если РеквизитыПисьма.Важность = Перечисления.ВажностьПисем.Высокая Тогда
			СтрокаКорня.ВажностьНомерКартинки = 2;
		ИначеЕсли РеквизитыПисьма.Важность = Перечисления.ВажностьПисем.Низкая ТОгда
			СтрокаКорня.ВажностьНомерКартинки = 0;
		Иначе
			СтрокаКорня.ВажностьНомерКартинки = 1;
		КонецЕсли;
		
		СтрокаКорня.Размер = РеквизитыПисьма.Размер / 1024;
		СтрокаКорня.ЕстьВложения = РеквизитыПисьма.ЕстьВложения;
		СтрокаКорня.НомерКартинки = 0;
		СтрокаКорня.ЭтоТекущаяЗадача = (ПисьмоРодитель = ТекущееПисьмо);
		СтрокаКорня.Вид = ?(ВстроеннаяПочтаКлиентСервер.ЭтоВходящееПисьмо(ПисьмоРодитель), 0, 1);
		
	КонецЕсли;
	
	Таблица = ВстроеннаяПочтаСервер.ПолучитьПодчиненныеПисьма(ПисьмоРодитель);
	Для НомерПисьма = 0 По Таблица.Количество() - 1 Цикл
		
		Письмо = Таблица[НомерПисьма];
		
		Если НомерПисьма = 0 И КорневойУровень Тогда
			
			ЗаполнитьУзелДереваПереписки(ЭлементыДерева, Письмо.Ссылка, КорневойУровень);
			
		Иначе
			
			ЗаполнитьУзелДереваПереписки(СтрокаКорня.ПолучитьЭлементы(), Письмо.Ссылка, Ложь);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьТекстHTMLСервер(Предпросмотр)
	СимвНачала = СтрНайти(Предпросмотр,"##<");
	Если СимвНачала <> 0 Тогда
		СимвКонца = СтрНайти(Предпросмотр,">##",НаправлениеПоиска.СНачала,СимвНачала);
		АдресТаблицыВложений = Сред(Предпросмотр,СимвНачала+3,СимвКонца-СимвНачала-3);
		ТекстПисьма = СтрЗаменить(Предпросмотр,"##<"+АдресТаблицыВложений+">##","");
		
		Если ЭтоАдресВременногоХранилища(АдресТаблицыВложений) Тогда
			ДанныеТаблицаВложений = ПолучитьИзВременногоХранилища(АдресТаблицыВложений);
			
			Если ТипЗнч(ДанныеТаблицаВложений) = Тип("Строка") Тогда
				ТаблицаВложенийССервера = ЗначениеИзСтрокиВнутр(ДанныеТаблицаВложений);
				Если ТипЗнч(ТаблицаВложенийССервера) = Тип("ТаблицаЗначений") Тогда
					ТаблицаВложений.Загрузить(ТаблицаВложенийССервера);
					УдалитьИзВременногоХранилища(АдресТаблицыВложений);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
///////////////////////////////////////////////////////////////////////////////
// РАБОТА С ПЕРСОНАЛЬНЫМИ СВОЙСТВАМИ ПИСЕМ

&НаКлиенте
Процедура ПредпросмотрHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ДанныеСобытия.Href <> Неопределено Тогда
		НачатьЗапускПриложения(Неопределено, ДанныеСобытия.Href);
	КонецЕсли;
	
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////////
// РАБОТА С ПОЛОЛЖЕНИЕМ ОБЛАСТИ ЧТЕНИЯ

&НаКлиенте
Процедура ОбластьЧтенияСнизу(Команда)
	
	ПоложениеОбластиЧтения = "Снизу";
	ОбновитьПоложениеОбластиЧтения();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбластьЧтенияСправа(Команда)
	
	ПоложениеОбластиЧтения = "Справа";
	ОбновитьПоложениеОбластиЧтения();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбластьЧтенияОтключена(Команда)
	
	ПоложениеОбластиЧтения = "Отключена";
	ОбновитьПоложениеОбластиЧтения();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПоложениеОбластиЧтения()
	
	ОбновитьПоложениеОбластиЧтенияСервер();
	ОбработатьАктивизациюСтрокиСписка();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПоложениеОбластиЧтенияСервер()
	
	Если ПоложениеОбластиЧтения = "Снизу" Тогда
		Элементы.ПредпросмотрHTML.Видимость = Истина;
		Элементы.ГруппаСписок.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		Элементы.ОбластьЧтенияСнизу.Пометка = Истина;
		Элементы.ОбластьЧтенияСправа.Пометка = Ложь;
		Элементы.ОбластьЧтенияОтключена.Пометка = Ложь;
		
	ИначеЕсли ПоложениеОбластиЧтения = "Справа" Тогда
		Элементы.ПредпросмотрHTML.Видимость = Истина;
		Элементы.ГруппаСписок.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		Элементы.ОбластьЧтенияСнизу.Пометка = Ложь;
		Элементы.ОбластьЧтенияСправа.Пометка = Истина;
		Элементы.ОбластьЧтенияОтключена.Пометка = Ложь;
		
	ИначеЕсли ПоложениеОбластиЧтения = "Отключена" Тогда
		Элементы.ПредпросмотрHTML.Видимость = Ложь;
		Элементы.ОбластьЧтенияСнизу.Пометка = Ложь;
		Элементы.ОбластьЧтенияСправа.Пометка = Ложь;
		Элементы.ОбластьЧтенияОтключена.Пометка = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

