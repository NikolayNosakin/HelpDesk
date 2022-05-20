﻿&НаКлиенте
Процедура КнопкаНайти(Команда)

	НайтиНаКлиенте(0);
	
	Если Не СлишкомМногоРезультатов И не ПустаяСтрока(СтрокаПоиска) Тогда
		СтруктураВозврата = Новый Структура();
		СтруктураВозврата.Вставить("ТекстСтраницыПоиска",HTMLТекст);
		СтруктураВозврата.Вставить("КоличествоНайденных",КоличествоРезультатов);
		СтруктураВозврата.Вставить("ИдентификаторПоиска",Новый УникальныйИдентификатор());
		Закрыть(СтруктураВозврата);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИндексНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	ПолнотекстовыйПоиск.ОбновитьИндекс(Ложь, Ложь);
	ИндексАктуален = ПолнотекстовыйПоиск.ИндексАктуален();
	Элементы.ГруппаОбновлениеИндекса.Видимость = Не ИндексАктуален;
	Элементы.ОбновитьИндекс.Доступность = Не ИндексАктуален;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИндекс(Команда)
	
	Состояние(НСтр("ru = 'Идет обновление полнотекстового индекса...
		|Пожалуйста, подождите.'"));
	
	ОбновитьИндексНаСервере();
	
	Состояние(НСтр("ru = 'Обновление полнотекстового индекса завершено.'"));

КонецПроцедуры

&НаКлиенте
Процедура НайтиНаКлиенте(Направление)
		
	Попытка
		
		Если ПустаяСтрока(СтрокаПоиска) Тогда
			Возврат;
		КонецЕсли;
		
		Если Направление = 0 Тогда
			
			Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Выполняется поиск ""%1""...'"),
				СтрокаПоиска));
			
		КонецЕсли;
		
		СохранениеВводимыхЗначенийКлиент.ОбновитьСписокВыбора(ЭтотОбъект, "СтрокаПоиска");
		
		НайтиНаСервере(Направление);
		Если Направление = 0 И СлишкомМногоРезультатов Тогда
			Предупреждение(НСтр("ru = 'Найдено слишком много результатов, уточните запрос.'"));
		КонецЕсли;
		
	Исключение
		ПоказатьПредупреждение(Неопределено,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки
	
КонецПроцедуры

&НаСервере
Процедура НайтиНаСервере(Направление)
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		HTMLТекст = ПолучитьПустойДокументHTML(Истина,"Ниего не найдено");
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрокаПоиска = ПолучитьСтрокуПоиска();
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(ТекущаяСтрокаПоиска, РезультатовНаСтранице);
	СписокПоиска.ОбластьПоиска = ПолучитьОбластьПоиска();
	СписокПоиска.ПорогНечеткости = ?(ИскатьСловаСОшибками, ПорогНечеткости, 0);
	СписокПоиска.ПолучатьОписание = ОтображатьТекстовоеОписание;
	
	ВремяНачалаПоиска = ТекущаяДата();
	
	Если Направление = 0 Тогда
		СписокПоиска.ПерваяЧасть();
	КонецЕсли;
	
	СлишкомМногоРезультатов = СписокПоиска.СлишкомМногоРезультатов();
	КоличествоРезультатов = СписокПоиска.Количество();
	ТекущаяПозиция = СписокПоиска.НачальнаяПозиция();
	ПолноеКоличество = СписокПоиска.ПолноеКоличество();
	
	Длительность = ТекущаяДата() - ВремяНачалаПоиска;
	ОписаниеСобытия = НСтр("ru='Строка поиска: '") + ТекущаяСтрокаПоиска;
	ДополнительныеСведения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Полное число результатов:%1  Размер порции:%2  Номер страницы:%3  Слишком много результатов:%4'"),
		ПолноеКоличество,
		РезультатовНаСтранице,
		ТекущаяПозиция / РезультатовНаСтранице + 1,
		Строка(СлишкомМногоРезультатов));
	
	Если ПолноеКоличество = 0 Тогда
		HTMLТекст = ПолучитьДокументHTMLНичегоНеНайдено();
	Иначе
		HTMLТекст = ПолучитьHTMLТекст(СписокПоиска);
	КонецЕсли;
	
	Инд = 0;
	Для каждого Результат Из СписокПоиска Цикл
		
		Если ТипЗнч(Результат.Значение) = Тип ("СправочникСсылка.СтатьиБазыЗнаний") Тогда
			АдресРезультата = "article:" + Результат.Значение.УникальныйИдентификатор() + "";
		ИначеЕсли ТипЗнч(Результат.Значение) = Тип ("СправочникСсылка.РазделыБазыЗнаний") Тогда	
			АдресРезультата = "category:" + Результат.Значение.УникальныйИдентификатор() + "";
		Иначе
			АдресРезультата = ПолучитьНавигационнуюСсылку(Результат.Значение);
		КонецЕсли;	
		HTMLТекст = СтрЗаменить(HTMLТекст,"href=""./"+Инд+"","href='"+АдресРезультата+"'");
		Инд = Инд + 1;
	КонецЦикла;
	
	// АбисСофт - Педаховский Юрий - 12 марта 2014 г. начало
	
	Если Объект.РасширенныйПоиск Тогда
		
		ПрименитьРасширенныйФильтр(HTMLТекст, СписокПоиска);
	КонецЕсли;
	
	// АбисСофт - Педаховский Юрий - 12 марта 2014 г. конец
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПустойДокументHTML(ВыводитьСправку = Ложь, Сообщение = "")
	
	Текст = Обработки.ПолнотекстовыйПоискВДанных.ПолучитьМакет("НичегоНеНайдено").ПолучитьТекст();
	Результат = СтрЗаменить(Текст, "%Сообщение%", Сообщение);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьДокументHTMLНичегоНеНайдено()
	
	Возврат Обработки.ПолнотекстовыйПоискВДанных.ПолучитьМакет("НичегоНеНайдено").ПолучитьТекст();
	
КонецФункции

// Возвращает строку поиска с учетом опции "Искать сочетания слов"
//
&НаСервере
Функция ПолучитьСтрокуПоиска()
	
	СтрокаПоиска = СокрЛП(СтрокаПоиска);
	
	Если ПолнотекстовыйПоискКлиентСервер.СтрокаПоискаСодержитСпецСимволы(СтрокаПоиска) Или ИскатьСловаСОшибками Тогда
		Результат = СтрокаПоиска;
	ИначеЕсли (Найти(СтрокаПоиска," ") = 0) И (Прав(СтрокаПоиска, 1) <> "*") Тогда // Всего 1 слово
		Результат = СтрокаПоиска + "*";
	ИначеЕсли ИскатьСочетанияСлов = 1 Тогда // Все слова в заданной последовательности
		Результат = """" + СтрокаПоиска + """";
	ИначеЕсли ИскатьСочетанияСлов = 2 Тогда // Любое из указанных слов
		Разделители = Новый Массив;
		Разделители.Добавить(" ");
		Разделители.Добавить(Символы.Таб);
		Разделители.Добавить(Символы.ВТаб);
		Разделители.Добавить(Символы.НПП);
		Результат = ЗаменитьРазделители(СтрокаПоиска, Разделители, " OR ");
	Иначе
		Результат = СтрокаПоиска;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьHTMLТекст(СписокПоиска)
	
	ТекущаяПозиция = СписокПоиска.НачальнаяПозиция();
	
	XML = СписокПоиска.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.XML);
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	Пока XML.Прочитать() Цикл
		ЗаписьXML.ЗаписатьТекущий(XML);
	КонецЦикла;
	XMLСтрока = ЗаписьXML.Закрыть();
	
	Преобразование = Новый ПреобразованиеXSL;
	CurPosition = Формат(1 + ТекущаяПозиция, "ЧН=; ЧГ=0");
	spanClass = ?(ВыделятьСловаЦветом, "color", "bold");
	
	ШаблонПреобразования = 
	
	"<?xml version=""1.0""?>
	|<xsl:stylesheet version=""1.0"" xmlns:xsl=""http://www.w3.org/1999/XSL/Transform"">
	|<xsl:output method = ""html""/>
	|<xsl:template match=""/"">
	|<html>
	|<body>
	|<div class='search_result'>
	|<xsl:apply-templates select=""//item""/>
	|</div>
	|</body>
	|</html>		
	|</xsl:template>	
	|<xsl:template match=""item"">
	|<xsl:variable name=""url"" select=""normalize-space(concat('./',index))""/>
	|<div class='index'>
	|<xsl:value-of select=""index+" + CurPosition + """/>.
	|</div>
	|<div class='presentation'>
	|<a id=""FullTextSearchListItem"" href=""{$url}""><xsl:value-of select=""metadata""/>: <xsl:value-of select=""presentation""/></a>
	|</div>
	|<xsl:apply-templates select=""textPortion""/>
	|"
	+ ?(ОтображатьДополнительнуюИнформацию, "
	|<div class='description'>
	|%<xsl:value-of select=""index""/>%
	|</div>"
	,
	""
	) + "
	|</xsl:template>
	
	|<xsl:template match=""textPortion"">
	|<div class='textPortion'>
	|<xsl:apply-templates/>
	|</div>
	|</xsl:template>
	
	|<xsl:template match=""foundWord"">
	|<span class = """ + spanClass + """><xsl:value-of select="".""/></span>
	|</xsl:template>
	
	|</xsl:stylesheet>";
	
	Преобразование.ЗагрузитьИзСтроки(ШаблонПреобразования);
	HTMLРезультат = Преобразование.ПреобразоватьИзСтроки(XMLСтрока);
	
	Если ОтображатьДополнительнуюИнформацию Тогда
		Для К = 0 По КоличествоРезультатов - 1 Цикл
			СтрокаЗамены = "%" + Формат(К, "ЧН=; ЧГ=0") + "%";
			ПапкиКатегорииСтр = ПолнотекстовыйПоискСерверПереопределяемый.ПолучитьДополнительнуюИнформациюПоОбъекту(СписокПоиска[К].Значение);
			Если Найти(HTMLРезультат, СтрокаЗамены) = 0 Тогда
				Сообщить(HTMLРезультат);
				Сообщить(СтрокаЗамены);
			КонецЕсли;
			HTMLРезультат = СтрЗаменить(HTMLРезультат, СтрокаЗамены, ПапкиКатегорииСтр);
		КонецЦикла;
	КонецЕсли;
	
	Возврат HTMLРезультат;
	
КонецФункции

// Возвращает массив метаданных, соответтсвующий выбранным разделам поиска
//
&НаСервере
Функция ПолучитьОбластьПоиска()
	
	Результат = Новый Массив;
	
	Результат.Добавить(Метаданные.Справочники.РазделыБазыЗнаний);
	Результат.Добавить(Метаданные.Справочники.СтатьиБазыЗнаний);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	РезультатовНаСтранице = 50;
	ОтображатьТекстовоеОписание = Истина;
	ВыделятьСловаЦветом = Истина;
	ИскатьСочетанияСлов = 0;
	ПорогНечеткости = 0;
	
	ЭтоФайловаяБаза = ПолучитьЭтоФайловаяБаза();
	
	// АбисСофт - Педаховский Юрий - 7 марта 2014 г. начало
	УстановитьВидимостьДоступностьЭлементов();	
	
	ПостроитьДеревоРазделовНаСервере();
	
	//ОбновитьАктуальностьИндекса();
	// АбисСофт - Педаховский Юрий - 7 марта 2014 г. конец
	
	ЭтоФайловаяБаза = ПолучитьЭтоФайловаяБаза();
	
	СохранениеВводимыхЗначений.ЗагрузитьСписокВыбора(ЭтотОбъект, "СтрокаПоиска");
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначенияДляОткрытия(Объект)
	
	Результат = Новый Массив;
	
	// Объект ссылочного типа
	Если ОбщегоНазначения.ЗначениеСсылочногоТипа(Объект) Тогда
		Результат.Добавить(Объект);
		Возврат Результат;
	КонецЕсли;
	
	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(Объект));
	ИмяМетаданного = МетаданныеОбъекта.Имя;
	
	ПолноеИмяОбъекта = ВРег(Метаданные.НайтиПоТипу(ТипЗнч(Объект)).ПолноеИмя());
	ЭтоРегистрСведений = (Найти(ПолноеИмяОбъекта, "РЕГИСТРСВЕДЕНИЙ.") > 0);
	
	Если Не ЭтоРегистрСведений Тогда // Регистр бухгалтерии или накопления или расчета
		Регистратор = Объект["Регистратор"];
		Результат.Добавить(Регистратор);
		Возврат Результат;
	КонецЕсли;
	
	// Ниже - это уже регистр сведений
	Если МетаданныеОбъекта.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
		Регистратор = Объект["Регистратор"];
		Результат.Добавить(Регистратор);
		Возврат Результат;
	КонецЕсли;
	
	// Независимый регистр сведений
	// Сперва - основные типы
	Для Каждого Измерение Из МетаданныеОбъекта.Измерения Цикл
		Если Измерение.Ведущее Тогда 
			ЗначениеИзмерения = Объект[Измерение.Имя];
			Если ОбщегоНазначения.ЗначениеСсылочногоТипа(ЗначениеИзмерения) Тогда
				Результат.Добавить(ЗначениеИзмерения);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Результат.Количество() = 0 Тогда
		// Теперь - любые типы
		Для Каждого Измерение Из МетаданныеОбъекта.Измерения Цикл
			Если Измерение.Ведущее Тогда 
				ЗначениеИзмерения = Объект[Измерение.Имя];
				Результат.Добавить(ЗначениеИзмерения);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Нет ни одного ведущего измерения - вернем сам ключ регистра сведений
	Если Результат.Количество() = 0 Тогда
		Результат.Добавить(Объект);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЗаменитьРазделители(Строка, Разделители, НовыйРазделитель)
	
	Результат = Строка;
	
	СтрокаЗамены = "%~%";
	ДлинаСтрокиЗамены = СтрДлина(СтрокаЗамены);
	Для каждого Разделитель Из Разделители Цикл
		Результат = СтрЗаменить(Результат, Разделитель, СтрокаЗамены);
	КонецЦИкла;
	Пока Найти(Результат, СтрокаЗамены + СтрокаЗамены) > 0 Цикл
		Результат = СтрЗаменить(Результат, СтрокаЗамены + СтрокаЗамены, СтрокаЗамены);
	КонецЦикла;
	Если Прав(Результат, ДлинаСтрокиЗамены) = СтрокаЗамены Тогда
		Результат = Сред(Результат, 1, СтрДлина(Результат) - ДлинаСтрокиЗамены);
	КонецЕсли;
	Если Лев(Результат, ДлинаСтрокиЗамены) = СтрокаЗамены Тогда
		Результат = Сред(Результат, 1 + ДлинаСтрокиЗамены);
	КонецЕсли;
	Результат = СтрЗаменить(Результат, СтрокаЗамены, НовыйРазделитель);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбновитьАктуальностьИндекса()
	
	Если ЭтоФайловаяБаза Тогда
		Элементы.ГруппаОбновлениеИндекса.Видимость = Истина;
		Попытка
			ИндексАктуален = ПолнотекстовыйПоиск.ИндексАктуален();
			Если ИндексАктуален Тогда
				Элементы.ГруппаОбновлениеИндекса.Видимость = Ложь;
				Элементы.ОбновитьИндекс.Доступность = Ложь;
			Иначе
				Элементы.ГруппаОбновлениеИндекса.Видимость = Истина;
				Элементы.ОбновитьИндекс.Доступность = Истина;
				ДатаАктуальностиИндекса = ПолнотекстовыйПоиск.ДатаАктуальности();
				Если ДатаАктуальностиИндекса = '00010101000000' Тогда
					СостояниеИндекса = НСтр("ru = 'Требуется обновление индекса'");
				Иначе
					СостояниеИндекса = НСтр("ru = 'Последнее обновление индекса: '") + Строка(ДатаАктуальностиИндекса);
				КонецЕсли;
				// АбисСофт - Педаховский Юрий - 7 марта 2014 г. начало
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СостояниеИндекса);
				// АбисСофт - Педаховский Юрий - 7 марта 2014 г. конец
				КонецЕсли;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
	Иначе
		Элементы.ГруппаОбновлениеИндекса.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьЭтоФайловаяБаза()
	
	СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
	Возврат ОбщегоНазначения.ИнформационнаяБазаФайловая(СтрокаСоединения);
	
КонецФункции

// АбисСофт - Педаховский Юрий - 7 марта 2014 г. начало

&НаКлиенте
Процедура РасширенныйПоиск(Команда)
	
	Объект.РасширенныйПоиск = Не Объект.РасширенныйПоиск;
	УстановитьВидимостьДоступностьЭлементов();

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Если Объект.РасширенныйПоиск Тогда
		Элементы.ГруппаРазделыПоиска.Видимость = Истина;
		Элементы.РасширенныйПоиск.Заголовок = НСтр("ru = 'Отключить расширенный поиск по разделам базы знаний'");
	Иначе
		Элементы.ГруппаРазделыПоиска.Видимость = Ложь;
		Элементы.РасширенныйПоиск.Заголовок = НСтр("ru = 'Включить расширенный поиск по разделам базы знаний'");
	КонецЕсли;
	
	Элементы.ДекорацияВнимание.Видимость = Объект.РасширенныйПоиск;
	
	ОбновитьАктуальностьИндекса();
	
	ПостроитьДеревоРазделовНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПостроитьДеревоРазделовНаСервере()
	
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	ДеревоЗначений = ОбъектСервер.РазделыПоиска;
	ДеревоЗначений.Строки.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РазделыБазыЗнаний.Родитель КАК Родитель,
	|	РазделыБазыЗнаний.Ссылка
	|ИЗ
	|	Справочник.РазделыБазыЗнаний КАК РазделыБазыЗнаний
	|
	|УПОРЯДОЧИТЬ ПО
	|	Родитель,
	|	РазделыБазыЗнаний.Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если НЕ ЗначениеЗаполнено(Выборка.Родитель) Тогда
			СтрокиРодитель = ДеревоЗначений.Строки;
		Иначе 
			СтрокаРодитель =  НайтиСтрокуДерева(ДеревоЗначений, Выборка.Родитель);
			Если СтрокаРодитель = Неопределено Тогда
				СтрокаРодитель = ДеревоЗначений;
			КонецЕсли;
			
			СтрокиРодитель = СтрокаРодитель.Строки;
		КонецЕсли;
		
		НоваяСтрока = СтрокиРодитель.Добавить();
		//НоваяСтрока.Использование	= Истина;
		НоваяСтрока.Раздел		= Выборка.Ссылка;
	КонецЦикла;
	
	// вернем заполеннную таблицу
	ЗначениеВРеквизитФормы(ОбъектСервер, "Объект");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиСтрокуДерева(Дерево, ИскомоеЗначение)
	
	СтрокаРодитель = Дерево.Строки.Найти(ИскомоеЗначение);
	Если СтрокаРодитель = Неопределено Тогда
		Для Каждого СтрокаДерева Из Дерево.Строки Цикл
			
			Если СтрокаРодитель <> неопределено Тогда
				Прервать;
			КонецЕсли;	

			СтрокаРодитель = НайтиСтрокуДерева(СтрокаДерева, ИскомоеЗначение);
		КонецЦикла;
	КонецЕсли;
	Возврат СтрокаРодитель;
КонецФункции

&НаСервере
Функция ПолучитьОтборПоКатегориям()
	
	// объект формы
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	
	Отбор = Новый Массив;
	Для Каждого СтрокаДерева из ОбъектСервер.РазделыПоиска.Строки Цикл
		
		// ищем необходимые отмеченные верхние уровни
		Если СтрокаДерева.Использование Тогда
			
			Отбор.Добавить(СтрокаДерева.Раздел);
		КонецЕсли;
		
		// развернем дерево
		РазвернутьСтрокиДерева(СтрокаДерева.Строки, Отбор);
	КонецЦикла;
	
	Возврат Отбор;	
КонецФункции

&НаСервереБезКонтекста
Процедура РазвернутьСтрокиДерева(СтрокиДерева, Отбор)
	
	Для Каждого СтрокаДерева из СтрокиДерева Цикл
		
		// ищем необходимые отмеченные верхние уровни
		Если СтрокаДерева.Использование Тогда
			
			Отбор.Добавить(СтрокаДерева.Раздел);
		КонецЕсли;
		
		// развернем дерево
		РазвернутьСтрокиДерева(СтрокаДерева.Строки, Отбор);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеОтбора(СправочникСсылка)
	Перем ТекстЗапроса;
	
	// отбор
	ОтборКатегории = ПолучитьОтборПоКатегориям();
	
	// получим статьи
	Если ОтборКатегории.Количество() > 0 Тогда
		
		// полчаем текст запроса
		Если СправочникСсылка.Метаданные() = Метаданные.Справочники.СтатьиБазыЗнаний Тогда
			
			ТекстЗапроса =  "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			                |	СтатьиБазыЗнаний.Ссылка
			                |ИЗ
			                |	Справочник.СтатьиБазыЗнаний КАК СтатьиБазыЗнаний
			                |ГДЕ
			                |	СтатьиБазыЗнаний.Ссылка = &ДанныеПоиска
			                |	И СтатьиБазыЗнаний.Разделы.Раздел В ИЕРАРХИИ(&Разделы)"; 
			
		ИначеЕсли СправочникСсылка.Метаданные() = Метаданные.Справочники.РазделыБазыЗнаний Тогда
			
			ТекстЗапроса =  "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			                |	РазделыБазыЗнаний.Ссылка
			                |ИЗ
			                |	Справочник.РазделыБазыЗнаний КАК РазделыБазыЗнаний
			                |ГДЕ
			                |	РазделыБазыЗнаний.Ссылка = &ДанныеПоиска
			                |	И РазделыБазыЗнаний.Ссылка В ИЕРАРХИИ(&Разделы)"; 
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапроса;
		Запрос.УстановитьПараметр("Разделы", ОтборКатегории);
		Запрос.УстановитьПараметр("ДанныеПоиска", СправочникСсылка);
		
		Возврат Запрос.Выполнить().Пустой();
	КонецЕсли;
	
	Возврат Истина;	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьОпределениеМетаданных(Представление)
	Перем НайденоОпределение;
	
	// если это Метаданные.Справочники.СтатьиБазыЗнаний
	Если ЗначениеЗаполнено(Метаданные.Справочники.СтатьиБазыЗнаний.ПредставлениеОбъекта) Тогда
		
		НайденоОпределение = НРег(Метаданные.Справочники.СтатьиБазыЗнаний.ПредставлениеОбъекта) = НРег(СокрЛП(Представление));
	Иначе
		
		НайденоОпределение = НРег(Метаданные.Справочники.СтатьиБазыЗнаний.Синоним) = НРег(СокрЛП(Представление));
	КонецЕсли;
	
	Если НайденоОпределение Тогда
		
		Возврат Метаданные.Справочники.СтатьиБазыЗнаний;
	КонецЕсли;
	
	// если это Метаданные.Справочники.РазделыБазыЗнаний
	Если ЗначениеЗаполнено(Метаданные.Справочники.РазделыБазыЗнаний.ПредставлениеОбъекта) Тогда
		
		НайденоОпределение = НРег(Метаданные.Справочники.РазделыБазыЗнаний.ПредставлениеОбъекта) = НРег(СокрЛП(Представление));
	Иначе
		
		НайденоОпределение = НРег(Метаданные.Справочники.РазделыБазыЗнаний.Синоним) = НРег(СокрЛП(Представление));
	КонецЕсли;
	
	Если НайденоОпределение Тогда
		
		Возврат Метаданные.Справочники.РазделыБазыЗнаний;
	КонецЕсли;
	
	Возврат НайденоОпределение;	
КонецФункции

&НаСервере
Процедура ПрименитьРасширенныйФильтр(ИточникDOM, РезультатПоиска)
	
	//Считываем в объект Документ с помощью ПостроительDOM 1С
	ЧтениеHTML = Новый ЧтениеHTML;
	ЧтениеHTML.УстановитьСтроку(ИточникDOM);
	ПостроительDOM  = Новый ПостроительDOM();
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеHTML);
	
	// данные очистки 
	УзлыПоОтбору = Новый Массив;
	
	// получим узлы в теге ссылки
	СписокУзловДОМ = ДокументDOM.ПолучитьЭлементыПоИмени("a"); 
	
	// обходим узлы
	Для Каждого УзелДОМ из СписокУзловДОМ Цикл
		
		Гиперссылка = УзелДОМ.Гиперссылка;
		Если ЗначениеЗаполнено(Гиперссылка) Тогда
			
			СправочникСсылка = Неопределено;
			
			// проверим принадлежность
			Если Найти(Гиперссылка, "article:") > 0 тогда
				
				Гиперссылка = СтрЗаменить(Гиперссылка, "article:", "");	
				СправочникСсылка = Справочники.СтатьиБазыЗнаний.ПолучитьСсылку(Новый УникальныйИдентификатор(Гиперссылка));
			КонецЕсли;
			
			// проверим принадлежность
			Если Найти(Гиперссылка, "category:") > 0 тогда
				
				Гиперссылка = СтрЗаменить(Гиперссылка, "category:", "");	
				СправочникСсылка = Справочники.РазделыБазыЗнаний.ПолучитьСсылку(Новый УникальныйИдентификатор(Гиперссылка));
			КонецЕсли;
			
			// проверим вхождение в отбор
			Если ЗначениеЗаполнено(СправочникСсылка) тогда
				
				РезультатОтбора = ПолучитьДанныеОтбора(СправочникСсылка);
				Если РезультатОтбора Тогда
					
					УзлыПоОтбору.Добавить(УзелДОМ.РодительскийУзел);	
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	// применить отбор
	ФорматироватьПоОтбору(УзлыПоОтбору);
	
	// обновим нумерацию
	КоличествоРезультатов = КоличествоРезультатов - УзлыПоОтбору.Количество();
	
	// произвести перенумерацию
	Если  УзлыПоОтбору.Количество() > 0 Тогда
		
		ПренумероватьПолученныйРезультат(ДокументDOM.ЭлементДокумента, "index", 1);
	КонецЕсли;

	НовыйЗаписьHTML = Новый ЗаписьHTML;  
	НовыйЗаписьHTML.УстановитьСтроку();
	
	ЗаписьДом = Новый ЗаписьDOM;
	ЗаписьДом.Записать(ДокументDOM, НовыйЗаписьHTML);
	
	ИточникDOM = НовыйЗаписьHTML.Закрыть();	
	
	//ВыражениеXPath = ДокументDOM.СоздатьВыражениеXPath("/html/body/div", Новый РазыменовательПространствИменDOM(ДокументDOM));
	//РезультатXPath = ВыражениеXPath.Вычислить(ДокументDOM);
	//УзелDOM = РезультатXPath.ПолучитьСледующий();
	//
	//Пока УзелDOM <> Неопределено Цикл 
	//	
	//	Для каждого Атрибута из УзелDOM.Атрибуты Цикл
	//		Сообщить(Атрибута.Имя + " = " + Атрибута.Значение);
	//	КонецЦикла;
	//	
	//	Для каждого Узла из УзелDOM.ДочерниеУзлы Цикл
	//		
	//		Сообщить(Узла.ИмяУзла);
	//		Если Узла.ИмяУзла = "HEAD" Тогда
	//			
	//			Для каждого Атрибута из Узла.Атрибуты Цикл
	//				Сообщить(Атрибута.Имя + " = " + Атрибута.Значение);
	//			КонецЦикла;
	//			
	//			Для каждого ДочернегоУзла из Узла.ПервыйДочерний.ДочерниеУзлы Цикл
	//				Сообщить(ДочернегоУзла.ИмяУзла + " = " + ДочернегоУзла.ТекстовоеСодержимое);
	//			КонецЦикла;
	//			
	//		ИначеЕсли Узла.ИмяУзла = "BODY" Тогда
	//			Для каждого ДочернегоУзла из Узла.ДочерниеУзлы Цикл
	//				Для каждого Атрибута из ДочернегоУзла.Атрибуты Цикл
	//					Сообщить(Атрибута.Имя + " = " + Атрибута.Значение);
	//				КонецЦикла;
	//			КонецЦикла;
	//		КонецЕсли;
	//		
	//	КонецЦикла;
	//	
	//	УзелDOM = РезультатXPath.ПолучитьСледующий();
	//КонецЦикла; 

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ФорматироватьПоОтбору(УзлыПоОтбору)
	
	// очистить предстваление
	Для каждого ТекУзелДОМ из УзлыПоОтбору Цикл
		
		ОчиститьУзлыВПределахРодителя(ТекУзелДОМ, "textPortion", Истина);
		ОчиститьУзлыВПределахРодителя(ТекУзелДОМ, "index", Ложь);
		ОчиститьУзлыВПределахРодителя(ТекУзелДОМ, "presentation");
	КонецЦикла; 
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОчиститьУзлыВПределахРодителя(ТекущийУзел, ТегДо,	Вверх = Неопределено)
	
	ОбрабатываемыйУзел = ТекущийУзел;
	
	Если Вверх = Истина Тогда
		
		ОбрабатываемыйУзел = ТекущийУзел.ПредыдущийСоседний;
	ИначеЕсли Вверх = Ложь Тогда 
		
		ОбрабатываемыйУзел = ТекущийУзел.СледующийСоседний;
	КонецЕсли;
	
	Если НЕ ОбрабатываемыйУзел = Неопределено Тогда
		Если ОбрабатываемыйУзел.ТипУзла = ТипУзлаDOM.Текст 
			ИЛИ (ОбрабатываемыйУзел.ТипУзла = ТипУзлаDOM.Элемент 
			И НЕ ОбрабатываемыйУзел.ИмяКласса = ТегДо) Тогда
			
			// запустим рекусивно
			ОчиститьУзлыВПределахРодителя(ОбрабатываемыйУзел, ТегДо, Вверх);
			
			// нужно удалить
			ОбрабатываемыйУзел.РодительскийУзел.УдалитьДочерний(ОбрабатываемыйУзел);
		ИначеЕсли ОбрабатываемыйУзел = ТекущийУзел Тогда 
			
			ОбрабатываемыйУзел.РодительскийУзел.УдалитьДочерний(ОбрабатываемыйУзел);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
 Процедура ПренумероватьПолученныйРезультат(ДокументDOM, ИмяКласса, Номер)
	 
	 // получим узлы в теге 
	 Для Каждого ТекущийУзел из ДокументDOM.ДочерниеУзлы Цикл
		 
		 Если ТекущийУзел.ТипУзла = ТипУзлаDOM.Элемент 
			 И ТекущийУзел.ИмяКласса = ИмяКласса Тогда
			 
			 Если НЕ ТекущийУзел.ПервыйДочерний =  Неопределено
				 И ТекущийУзел.ПервыйДочерний.ТипУзла = ТипУзлаDOM.Текст Тогда
				 
				    ТекущийУзел.ПервыйДочерний.ТекстовоеСодержимое  = Строка(Номер) + ".";
					Номер = Номер + 1;
				КонецЕсли;
			Иначе
				
				 ПренумероватьПолученныйРезультат(ТекущийУзел, ИмяКласса, Номер);
		 КонецЕсли;
	 КонецЦикла;
 
 КонецПроцедуры

&НаКлиенте
 Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылка, СтандартнаяОбработка)
	 Сообщить("");
 КонецПроцедуры

// АбисСофт - Педаховский Юрий - 7 марта 2014 г. конец
