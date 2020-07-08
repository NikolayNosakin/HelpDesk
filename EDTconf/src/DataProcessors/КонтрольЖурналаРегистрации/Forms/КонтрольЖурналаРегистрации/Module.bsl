// Обработчик события формы "при создании на сервере".
// Выполняет инициализацию реквизитов периода.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОкончаниеПериодаВыборки = ТекущаяДата();
	НачалоПериодаВыборки    = ОкончаниеПериодаВыборки - 86400;
	ОбновитьОтчетНаФорме();
	ИдентификаторРегламентногоЗадания = 
	              РегламентныеЗадания.НайтиПредопределенное(
	                       Метаданные.РегламентныеЗадания.КонтрольЖурналаРегистрации).УникальныйИдентификатор;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРасписание()
	
	УстановитьПривилегированныйРежим(Истина);
	
	МодульРегламентныеЗаданияСервер = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("РегламентныеЗаданияСервер");
	Возврат МодульРегламентныеЗаданияСервер.ПолучитьРасписаниеРегламентногоЗадания(
		ИдентификаторРегламентногоЗадания);
	
КонецФункции

&НаСервере
Процедура УстановитьРасписание(Знач Расписание)
	
	УстановитьПривилегированныйРежим(Истина);
	
	МодульРегламентныеЗаданияСервер = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("РегламентныеЗаданияСервер");	
	МодульРегламентныеЗаданияСервер.УстановитьРасписаниеРегламентногоЗадания(
		ИдентификаторРегламентногоЗадания,
		Расписание);
	
КонецПроцедуры

// Обработчик нажатия на кнопку "Обновить"
//
&НаКлиенте
Процедура ОбновитьОтчетНаФормеВыполнить()
	
	ОчиститьСообщения();
	ФормироватьОтчет = Истина;
	Если Не ЗначениеЗаполнено(НачалоПериодаВыборки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru='Не заполнена дата/время начала периода выборки.';uk='Не заповнена дата/час початку періоду вибірки.'"), ,
					"НачалоПериодаВыборки");
		ФормироватьОтчет = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОкончаниеПериодаВыборки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		              НСтр("ru='Не заполнена дата/время окончания периода выборки.';uk='Не заповнена дата/час закінчення періоду вибірки.'"), ,
		              "ОкончаниеПериодаВыборки");
		ФормироватьОтчет = Ложь;
	КонецЕсли;
	Если ФормироватьОтчет Тогда
		ОбновитьОтчетНаФорме();
	КонецЕсли;
	
КонецПроцедуры

// Получает данные по ошибкам из журнала регистрации и формирует
// по нима отчет. Отчет выводится на форму.
//
&НаСервере
Процедура ОбновитьОтчетНаФорме()
	
	// по полученным данным формируем отчет и записываем его на диск
	РезультатФормированияОтчета =
	   Обработки.КонтрольЖурналаРегистрации.СформироватьОтчет(
	                         НачалоПериодаВыборки,
	                         ОкончаниеПериодаВыборки);
	
	Отчет = РезультатФормированияОтчета.Отчет;
	
КонецПроцедуры

// Обработчик события нажатия на кнопку "Получатели отчета".
//
&НаКлиенте
Процедура УказатьПолучателейОтчетаВыполнить()
	
	ОткрытьФорму("Обработка.КонтрольЖурналаРегистрации.Форма.УстановкаПочтовыхАдресовДляОтправкиОтчета");
	
КонецПроцедуры

// Обработчик команды "Расписание регламентного задания".
//
&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗаданияВыполнить()
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ПолучитьРасписание());
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения(
			"НастроитьРасписаниеРегламентногоЗаданияВыполнитьПродолжение",
			ЭтотОбъект);
	
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗаданияВыполнитьПродолжение(Расписание, Параметры) Экспорт
	
	Если Расписание <> Неопределено Тогда
		УстановитьРасписание(Расписание);
	КонецЕсли;
	
КонецПроцедуры



