﻿
// Процедура для получения отчета по ошибкам и предупреждениям журнала регистрации
// Параметры
// НачалоПериодаВыборки - Дата/ДатаВремя - нижняя граница периода выборки
// ОкончаниеПериодаВыборки - Дата/ДатаВремя - верхняя граница периода выборки
// СохранятьВремяПоследнейВыборки - Булево - если истина, то при успешной выборке
//                 в хранилище системных настроек будет записано время окончания
//                 периода текущей выборки
//
// Прим
// Если период выборки не указан, то выборка производится за последние сутки, если
// ранее было сохранено время выборки, то это время устанавливается в качестве
// начала периода.
//
//
Процедура СформироватьОтчетПоОшибкамИПослатьОтчет(Знач НачалоПериодаВыборки = Неопределено,
                                                  Знач ОкончаниеПериодаВыборки = Неопределено,
                                                  Знач СохранятьВремяПоследнейВыборки = Истина) Экспорт
	
	Если ЗначениеЗаполнено(НачалоПериодаВыборки)
	   И ЗначениеЗаполнено(ОкончаниеПериодаВыборки) Тогда
		ПериодВыборки = Новый Структура;
		ПериодВыборки.Вставить("НачалоПериода",    НачалоПериодаВыборки);
		ПериодВыборки.Вставить("ОкончаниеПериода", ОкончаниеПериодаВыборки);
	Иначе
		ПериодВыборки = ПолучитьПериодВыборкиДанных();
	КонецЕсли;
	
	// по полученным данным формируем отчет и записываем его на диск
	РезультатФормированияОтчета = СформироватьОтчет(ПериодВыборки.НачалоПериода,
	                                                ПериодВыборки.ОкончаниеПериода);
	
	Отчет = РезультатФормированияОтчета.Отчет;
	
	ИмяФайлаОтчета = ПолучитьИмяВременногоФайла();
	
	Отчет.Записать(ИмяФайлаОтчета);
	
	// формируем и отправляем письмо
	Вложения = Новый Соответствие;
	
	Вложения.Вставить("report.mxl", Новый ДвоичныеДанные(ИмяФайлаОтчета));
	
	УдалитьФайлы(ИмяФайлаОтчета);
	
	ПараметрыПисьма = Новый Структура;
	
	ПолучателиОтчета = КонтрольЖурналаРегистрации.ПолучитьАдресатовПолученияОтчетаПоЖурналуРегистрации();
	
	Если ПустаяСтрока(ПолучателиОтчета) Тогда
		ВызватьИсключение НСтр("ru='Не указан ни один получатель отчета по ошибкам и предупреждениям журнала регистрации.';uk='Не зазначений жоден одержувач звіту по помилках і попередженням журналу реєстрації.'");
		
	КонецЕсли;
	
	ПараметрыПисьма.Вставить("Кому", ПолучателиОтчета);
	
	ПредставлениеИБ = ОбщегоНазначения.ПолучитьПредставлениеИнформационнойБазы();
	
	ПараметрыПисьма.Вставить("Тема",
	                СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	                  НСтр("ru='Контроль журнала регистрации: %1.';uk='Контроль журналу реєстрації: %1.'"), ПредставлениеИБ ));
	
	ТекстТелаПисьма = НСтр("ru='Информация по ошибкам и предупреждениям журнала регистрации."
"Информационная база: %1."
"Период выборки данных: c %2 по %3."
"Всего ошибок: %4."
"Всего предупреждений: %5."
"Во вложении находится подробный отчет по ошибкам и предупреждениям."
"За более детальной информацией необходимо обращаться к журналу регистрации.';uk='Інформація з помилок і попереджень журналу реєстрації."
"Інформаційна база: %1."
"Період вибірки даних: c %2 по %3."
"Усього помилок: %4."
"Усього попереджень: %5."
"У вкладенні перебуває докладний звіт по помилках і попередженням."
"За більше детальною інформацією необхідно звертатися до журналу реєстрації.'");
	
	ТекстТелаПисьма = 
	            СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	                  ТекстТелаПисьма,
	                  ПредставлениеИБ,
	                  ПериодВыборки.НачалоПериода,
	                  ПериодВыборки.ОкончаниеПериода,
	                  РезультатФормированияОтчета.ИтогПоОшибкам,
	                  РезультатФормированияОтчета.ИтогПоПредупреждениям );
	
	ПараметрыПисьма.Вставить("Тело", ТекстТелаПисьма);
	
	ПараметрыПисьма.Вставить("Вложения", Вложения);
	
	РаботаСПочтовымиСообщениями
		.ОтправитьСообщение(РаботаСПочтовымиСообщениями.ПолучитьСистемнуюУчетнуюЗапись(),
							ПараметрыПисьма);
	
	Если СохранятьВремяПоследнейВыборки Тогда
		СохранитьВремяПоследнейВыборкиИнформации(ПериодВыборки.ОкончаниеПериода);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЕРВИСНЫЕ ФУНКЦИИ

// Функция получает информацию по ошибкам в журнале регистрации по переданному периоду
// Параметры
// НачалоПериода    - дата - начала периода, по которому будет собираться информация
// ОкончаниеПериода - дата - окончание периода, по которому будет собираться информация
//
// Возвращаемое значение
// таблица значений - записи из журнала регистрации в соответствии с фильтром:
//                    УровеньЖурналаРегистрации - УровеньЖурналаРегистрации.Ошибка
//                    Начало и Окончание периода - из параметров
//
Функция ПолучитьИнформациюПоОшибкамЖурналаРегистрации(Знач НачалоПериода, Знач ОкончаниеПериода)
	
	ДанныеЖурналаРегистрации = Новый ТаблицаЗначений;
	
	УровниРегистрацииОшибок = Новый Массив;
	УровниРегистрацииОшибок.Добавить(УровеньЖурналаРегистрации.Ошибка);
	УровниРегистрацииОшибок.Добавить(УровеньЖурналаРегистрации.Предупреждение);
	
	ВыгрузитьЖурналРегистрации(ДанныеЖурналаРегистрации,
	                           Новый Структура("Уровень, ДатаНачала, ДатаОкончания",
	                                           УровниРегистрацииОшибок,
	                                           НачалоПериода,
	                                           ОкончаниеПериода));
	
	Возврат ДанныеЖурналаРегистрации;
	
КонецФункции

// Служебная процедура, определяющая период времени, за который требуется получить
// данные из журнала регистрации. Кроме того по переданному ключу записывает
// окончание периода в хранилище системнеых настроек - для использования
// при следующем вызове
//
Функция ПолучитьПериодВыборкиДанных()
	
	Результат = Новый Структура;
	
	ВремяПоследнейВыборкиИнформации = ПолучитьВремяПоследнейВыборкиИнформации();
	
	ОкончаниеПериода = ТекущаяДата();
	
	Если ВремяПоследнейВыборкиИнформации = Неопределено Тогда // если регламентное задание еще не выполнялось - выбираем данные за сутки
		НачалоПериода = ОкончаниеПериода - 86400;
	Иначе
		НачалоПериода = ВремяПоследнейВыборкиИнформации;
	КонецЕсли;
	
	Результат.Вставить("НачалоПериода",    НачалоПериода);
	Результат.Вставить("ОкончаниеПериода", ОкончаниеПериода);
	
	Возврат Результат;
	
КонецФункции

// Получает время предыдущего процесса сбора иинформации из журнала регистрации
//
Функция ПолучитьВремяПоследнейВыборкиИнформации()
	
	ВремяПоследнейВыборкиИнформации = Неопределено;
	
	ПараметрыОтчета = ХранилищеОбщихНастроек.Загрузить("ПараметрыОтчетаПоЖурналуРегистрации");
	
	Если ПараметрыОтчета <> Неопределено Тогда
		ПараметрыОтчета.Свойство("ВремяПоследнейВыборкиИнформации", ВремяПоследнейВыборкиИнформации);
	КонецЕсли;
	
	Возврат ВремяПоследнейВыборкиИнформации;
	
КонецФункции

// Сохраняет время предыдущего процесса сбора иинформации из журнала регистрации
//
Процедура СохранитьВремяПоследнейВыборкиИнформации(ВремяПоследнейВыборкиИнформации)
	
	ПараметрыОтчета = ХранилищеОбщихНастроек.Загрузить("ПараметрыОтчетаПоЖурналуРегистрации");
	
	Если ПараметрыОтчета = Неопределено Или ТипЗнч(ПараметрыОтчета) <> Тип("Структура") Тогда
		ПараметрыОтчета = Новый Структура;
	КонецЕсли;
	
	ПараметрыОтчета.Вставить("ВремяПоследнейВыборкиИнформации", ВремяПоследнейВыборкиИнформации);
	
	ХранилищеОбщихНастроек.Сохранить("ПараметрыОтчетаПоЖурналуРегистрации", ,
	                                     ПараметрыОтчета);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Блок функций для формирования отчета

// Функция, формирующая отчет по зарегистрированным в журнале регистрации ошибкам
// Параметры
// ДанныеЖурналаРегистрации - таблица значений - выгруженная таблица из журнала регистраций
// должны присутствовать следующие колонки: Дата, ИмяПользователя, ПредставлениеПриложения,
//                                          ПредставлениеСобытия, Комментарий, Уровень
//
Функция СформироватьОтчет(	Знач НачалоПериода,
							Знач ОкончаниеПериода) Экспорт
	
	Результат = Новый Структура;
	
	Отчет = Новый ТабличныйДокумент;
	
	Макет = Обработки.КонтрольЖурналаРегистрации.ПолучитьМакет("МакетОтчетаПоОшибкамВЖурналеРегистрации");
	
	ДанныеЖурналаРегистрации = ПолучитьИнформациюПоОшибкамЖурналаРегистрации(НачалоПериода, ОкончаниеПериода);
	
	///////////////////////////////////////////////////////////////////////////////
	// Блок предварительной подготовки данных
	//
	
	СверткаПоКомментариям = ДанныеЖурналаРегистрации.Скопировать();
	СверткаПоКомментариям.Колонки.Добавить("ИтогПоКомментарию");
	СверткаПоКомментариям.ЗаполнитьЗначения(1, "ИтогПоКомментарию");
	СверткаПоКомментариям.Свернуть("Уровень, Комментарий, Событие, ПредставлениеСобытия", "ИтогПоКомментарию");
	
	МассивСтрок_УровеньОшибка = СверткаПоКомментариям.НайтиСтроки(
									Новый Структура("Уровень", УровеньЖурналаРегистрации.Ошибка));
	
	МассивСтрок_УровеньПредупреждение = СверткаПоКомментариям.НайтиСтроки(
									Новый Структура("Уровень", УровеньЖурналаРегистрации.Предупреждение));
	
	Свертка_Ошибки         = СверткаПоКомментариям.Скопировать(МассивСтрок_УровеньОшибка);
	Свертка_Ошибки.Сортировать("ИтогПоКомментарию Убыв");
	Свертка_Предупреждения = СверткаПоКомментариям.Скопировать(МассивСтрок_УровеньПредупреждение);
	Свертка_Предупреждения.Сортировать("ИтогПоКомментарию Убыв");
	
	///////////////////////////////////////////////////////////////////////////////
	// Блок формирования самого отчета
	//
	
	Область = Макет.ПолучитьОбласть("ШапкаОтчета");
	Область.Параметры.ПериодВыборкиНачало    = НачалоПериода;
	Область.Параметры.ПериодВыборкиОкончание = ОкончаниеПериода;
	Область.Параметры.ПредставлениеИнформационнойБазы = ОбщегоНазначения.ПолучитьПредставлениеИнформационнойБазы();
	Отчет.Вывести(Область);
	
	РезультатКомпоновкиТЧ = СформироватьТабличнуюЧасть(Макет, ДанныеЖурналаРегистрации, Свертка_Ошибки);
	
	Отчет.Вывести(Макет.ПолучитьОбласть("ПустаяСтрока"));
	Область = Макет.ПолучитьОбласть("ЗаголовокБлокаОшибки");
	Область.Параметры.ЧислоОшибок = Строка(РезультатКомпоновкиТЧ.Итог);
	Отчет.Вывести(Область);
	
	Если РезультатКомпоновкиТЧ.Итог > 0 Тогда
		Отчет.Вывести(РезультатКомпоновкиТЧ.ТабличнаяЧасть);
	КонецЕсли;
	
	Результат.Вставить("ИтогПоОшибкам", РезультатКомпоновкиТЧ.Итог);
	
	РезультатКомпоновкиТЧ = СформироватьТабличнуюЧасть(Макет, ДанныеЖурналаРегистрации, Свертка_Предупреждения);
	
	Отчет.Вывести(Макет.ПолучитьОбласть("ПустаяСтрока"));
	Область = Макет.ПолучитьОбласть("ЗаголовокБлокаПредупреждения");
	Область.Параметры.ЧислоПредупреждений = РезультатКомпоновкиТЧ.Итог;
	Отчет.Вывести(Область);
	
	Если РезультатКомпоновкиТЧ.Итог > 0 Тогда
		Отчет.Вывести(РезультатКомпоновкиТЧ.ТабличнаяЧасть);
	КонецЕсли;
	
	Результат.Вставить("ИтогПоПредупреждениям", РезультатКомпоновкиТЧ.Итог);
	
	Отчет.ОтображатьСетку = Ложь;
	
	Результат.Вставить("Отчет", Отчет);
	
	Возврат Результат;
	
КонецФункции

// Добавляет в отчет табличную часть по ошибкам. Ошибки выводятся сгруппированными
// по комментарию.
// Параметры:
// Отчет  - ТабличныйДокумент - непосредственно отчет, в который будет выводится
//                              информация
// Макет  - ТабличныйДокумент - источник форматированных областей, которые будут
//                              использоваться при формировании отчета
// ДанныеЖурналаРегистрации   - ТаблицаЗначений - данные по ошибкам и предупреждениям
//                              из журнала регистрации "как есть"
// СвернутыеДанные - ТаблицаЗначений - свернутая по комметариям информация по их количеству
//
Функция СформироватьТабличнуюЧасть(Макет, ДанныеЖурналаРегистрации, СвернутыеДанные)
	
	Отчет = Новый ТабличныйДокумент;
	
	Итог = 0;
	
	Если СвернутыеДанные.Количество() > 0 Тогда
		Отчет.Вывести(Макет.ПолучитьОбласть("ПустаяСтрока"));
		
		Для Каждого Запись Из СвернутыеДанные Цикл
			Итог = Итог + Запись.ИтогПоКомментарию;
			МассивСтрок = ДанныеЖурналаРегистрации.НайтиСтроки(
			                   Новый Структура("Уровень, Комментарий",
			                           УровеньЖурналаРегистрации.Ошибка,
			                           Запись.Комментарий));
			
			Область = Макет.ПолучитьОбласть("ТелоТабличнойЧастиШапка");
			Область.Параметры.Заполнить(Запись);
			Отчет.Вывести(Область);
			
			Отчет.НачатьГруппуСтрок(, Ложь);
			Для Каждого Строка Из МассивСтрок Цикл
				Область = Макет.ПолучитьОбласть("ТелоТабличнойЧастиДетализация");
				Область.Параметры.Заполнить(Строка);
				Отчет.Вывести(Область);
			КонецЦикла;
			Отчет.ЗакончитьГруппуСтрок();
			Отчет.Вывести(Макет.ПолучитьОбласть("ПустаяСтрока"));
		КонецЦикла;
	КонецЕсли;
	
	Результат = Новый Структура("ТабличнаяЧасть, Итог", Отчет, Итог);
	
	Возврат Результат;
	
КонецФункции

