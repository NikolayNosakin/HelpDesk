﻿/////////////////////////////////////////////////////////////////////////////////////////
// РАБОТА С ЖУРНАЛОМ РЕГИСТРАЦИИ

// Записывает ошибку в журнал регистрации.
//
Процедура ЗаписатьОшибкуВЖурналРегистрации(Знач ТекстОшибки, Знач Данные = Неопределено) Экспорт
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Почта'"),
		УровеньЖурналаРегистрации.Ошибка,,
		Данные,
		ТекстОшибки);
	
КонецПроцедуры

// Записывает информацию в журнал регистрации.
//
Процедура ЗаписатьИнформациюВЖурналРегистрации(Знач ТекстИнформации, Знач Данные = Неопределено) Экспорт
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Почта'"),
		УровеньЖурналаРегистрации.Информация,,
		Данные,
		ТекстИнформации);
	
КонецПроцедуры


/////////////////////////////////////////////////////////////////////////////////////////
// РАБОТА С УЧЕТНЫМИ ЗАПИСЯМИ

// Проверяет, что указанное значение является учетной записью.
//
Функция ЭтоУчетнаяЗапись(Значение) Экспорт
	
	Возврат (ТипЗнч(Значение) = Тип("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты"));
	
КонецФункции

// Возвращает структуру, содержащую сведения об учетной записи.
//
Функция ПолучитьДанныеУчетнойЗаписи(УчетнаяЗапись) Экспорт
	
	Результат = Новый Структура(
		"Ссылка,
		|ПометкаУдаления,
		|Предопределенный,
		|Наименование,
		|АдресЭлектроннойПочты,
		|ВариантИспользования,
		|ИмяПользователя,
		|ИспользоватьДляОтправки,
		|ИспользоватьДляПолучения,
		|Пароль,
		|ВПредставлениеВключатьИмяПользователя,
		|ОставлятьКопииСообщенийНаСервере,
		|ПериодХраненияСообщенийНаСервере,
		|ПредставлениеАдресаЭлектроннойПочты,
		|ОтображаемоеИмя");
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УчетныеЗаписиЭлектроннойПочты.Ссылка,
		|	УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления,
		|	УчетныеЗаписиЭлектроннойПочты.Предопределенный,
		|	УчетныеЗаписиЭлектроннойПочты.Наименование,
		|	УчетныеЗаписиЭлектроннойПочты.АдресЭлектроннойПочты,
		|	УчетныеЗаписиЭлектроннойПочты.ВариантИспользования,
		|	УчетныеЗаписиЭлектроннойПочты.ИмяПользователя,
		|	УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляОтправки,
		|	УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляПолучения,
		|	УчетныеЗаписиЭлектроннойПочты.Пароль,
		|	УчетныеЗаписиЭлектроннойПочты.ВПредставлениеВключатьИмяПользователя,
		|	УчетныеЗаписиЭлектроннойПочты.ОставлятьКопииСообщенийНаСервере,
		|	УчетныеЗаписиЭлектроннойПочты.ПериодХраненияСообщенийНаСервере
		|ИЗ
		|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
		|ГДЕ
		|	УчетныеЗаписиЭлектроннойПочты.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", УчетнаяЗапись);
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Данные = РезультатЗапроса.Выгрузить()[0];
		ЗаполнитьЗначенияСвойств(Результат, Данные);
		Если Данные.ВПредставлениеВключатьИмяПользователя Тогда
			Результат.ПредставлениеАдресаЭлектроннойПочты = РаботаСоСтроками.ПолучитьПредставлениеАдресаЭлектроннойПочты(
				Данные.ИмяПользователя,
				Данные.АдресЭлектроннойПочты);
			Результат.ОтображаемоеИмя = Данные.ИмяПользователя;
		Иначе
			Результат.ПредставлениеАдресаЭлектроннойПочты = РаботаСоСтроками.ПолучитьПредставлениеАдресаЭлектроннойПочты(
				"",
				Данные.АдресЭлектроннойПочты);
			Результат.ОтображаемоеИмя = "";
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Получает все доступные учетные записи, удовлетворяющие параметрам отбора
// ПараметрыОтбора (Структура) - необязательный
// - ИспользоватьДляОтправки (Булево) - необязательный
// - ИспользоватьДляПолучения (Булево) - необязательный
// - ВариантИспользования (Перечисление.ВариантыИспользованияПочты) - необязательный
// - Предопределенный (Булево) - необязательный
//
Функция ПолучитьУчетныеЗаписиЭлектроннойПочты(Знач ПараметрыОтбора = Неопределено) Экспорт
	
	ИспользоватьДляОтправки = Неопределено;
	ИспользоватьДляПолучения = Неопределено;
	ВариантИспользования = Неопределено;
	Предопределенный = Неопределено;
	Если ПараметрыОтбора <> Неопределено Тогда
		ПараметрыОтбора.Свойство("ИспользоватьДляОтправки", ИспользоватьДляОтправки);
		ПараметрыОтбора.Свойство("ИспользоватьДляПолучения", ИспользоватьДляПолучения);
		ПараметрыОтбора.Свойство("ВариантИспользования", ВариантИспользования);
		ПараметрыОтбора.Свойство("Предопределенный", Предопределенный);
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	УчетныеЗаписиЭлектроннойПочты.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
		|ГДЕ
		|	(УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляОтправки = &ИспользоватьДляОтправки
		|			ИЛИ &ИспользоватьДляОтправки = НЕОПРЕДЕЛЕНО)
		|	И (УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляПолучения = &ИспользоватьДляПолучения
		|			ИЛИ &ИспользоватьДляПолучения = НЕОПРЕДЕЛЕНО)
		|	И (УчетныеЗаписиЭлектроннойПочты.ВариантИспользования = &ВариантИспользования
		|			ИЛИ &ВариантИспользования = НЕОПРЕДЕЛЕНО)
		|	И (УчетныеЗаписиЭлектроннойПочты.Предопределенный = &Предопределенный
		|			ИЛИ &Предопределенный = НЕОПРЕДЕЛЕНО)
		|	И НЕ УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления");
	Запрос.УстановитьПараметр("ИспользоватьДляОтправки", ИспользоватьДляОтправки);
	Запрос.УстановитьПараметр("ИспользоватьДляПолучения", ИспользоватьДляПолучения);
	Запрос.УстановитьПараметр("ВариантИспользования", ВариантИспользования);
	Запрос.УстановитьПараметр("Предопределенный", Предопределенный);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции


/////////////////////////////////////////////////////////////////////////////////////////
// РАБОТА С ИНТЕРНЕТ ПОЧТОЙ

// Устанавливает соединение с почтовым сервером.
// Параметры:
// - УчетнаяЗапись (УчетныеЗаписиЭлектроннойПочты)
// - Пароль (Строка) - необязательный
//
Функция ИнтернетПочтаУстановитьСоединение(
	Знач УчетнаяЗапись,
	Знач Пароль = Неопределено,
	СообщениеОбОшибке = Неопределено) Экспорт
	
	Попытка
		
		Профиль = Неопределено;
		Если ЗначениеЗаполнено(Пароль) Тогда
			Профиль = ЭлектроннаяПочта.СформироватьИнтернетПрофиль(УчетнаяЗапись, Пароль);
		Иначе
			Профиль = ЭлектроннаяПочта.СформироватьИнтернетПрофиль(УчетнаяЗапись);
		КонецЕсли;
		Соединение = Новый ИнтернетПочта;
		//Соединение.Подключиться(Профиль);
		Соединение.Подключиться(Профиль,?(УчетнаяЗапись.ИспользоватьIMAP,ПротоколИнтернетПочты.IMAP,ПротоколИнтернетПочты.POP3));

	Исключение
		
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьОшибкуВЖурналРегистрации(СообщениеОбОшибке);
		
		Возврат Неопределено;
		
	КонецПопытки;
	
	Возврат Соединение;
	
КонецФункции

// Возвращает массив идентификаторов.
//
Функция ПолучитьИдентификаторыВходящихСообщений(
	Соединение,
	МассивИдентификаторов = Неопределено,
	ПараметрыОтбора = Неопределено,
	СообщениеОбОшибке = Неопределено) Экспорт
	
	Попытка
		
		Результат = Новый Массив;
		Если ЗначениеЗаполнено(МассивИдентификаторов) И ЗначениеЗаполнено(ПараметрыОтбора) Тогда
			Результат = Соединение.ПолучитьИдентификаторы(МассивИдентификаторов, ПараметрыОтбора);
		ИначеЕсли ЗначениеЗаполнено(МассивИдентификаторов) Тогда
			Результат = Соединение.ПолучитьИдентификаторы(МассивИдентификаторов);
		ИначеЕсли ЗначениеЗаполнено(ПараметрыОтбора) Тогда
			Результат = Соединение.ПолучитьИдентификаторы(, ПараметрыОтбора);
		Иначе
			Результат = Соединение.ПолучитьИдентификаторы();
		КонецЕсли;
		
	Исключение
		
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьОшибкуВЖурналРегистрации(СообщениеОбОшибке);
		
		Возврат Неопределено;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Загружает почтовые сообщения, возвращает массив структур почтовых сообщений.
// Параметры:
// - ПараметрыЗагрузки (Структура)
//   - Соединение (ИнтернетПочта) - необязательный
//   - Профиль (ИнтернетПрофиль) - необязательный
//   - УчетнаяЗапись (СправочникСсылка.УчетныеЗапсиЭлектроннойПочты) - необязательный
//   - Пароль (Строка) - необязательный
//   - Идентификаторы (Массив)
//   - ПолучитьЗаголовки (Булево)
//   - ПараметрыОтбора (Структура)
//     - ОтправленОтвет (Answered) - Булево. Отобрать сообщения, у которых установлен флаг – Answered; 
//     - ПолученОтвет (Recent) - Булево. Отобрать сообщения, у которых установлен флаг – Recent; 
//     - СлепыеКопии (Bcc) - Строка. Отобрать сообщения, которые имеют “строка” в поле Bcc; 
//     - Копии (Cc) - Строка. Отобрать сообщения, которые имеют “строка” в поле Cc; 
//     - Получатели (To) - Строка. Отобрать сообщения, которые имеют “строка” в поле To; 
//     - ДатаОтправки (PostDating) - Дата. Отобрать сообщения, у которых значение поле Date: равно “Дата”; 
//     - Отправитель (From) - Строка. Отобрать все сообщения у которых встречается “строка”в поле From; 
//     - ДоДатыОтправления (BeforeDateOfPosting) - Дата. Отобрать сообщения, у которых значение поле Date: перед “дата”; 
//     - ПослеДатыОтправления (AfterDateOfPosting) - Дата. Отобрать сообщения, у которых значение поля Date: после значения “Дата”; 
//     - Тема (Subject) - Строка. Отобрать сообщения, в заголовке которых встречается заданная строка; 
//     - Текст (Text) - Строка. Отобрать сообщения, в любых текстовых полях которого встречается заданная строка; 
//     - ТелоСообщения (Body) - Строка. Отобрать сообщения, в теле которых встречается строка – “строка”; 
//     - Удаленные (Deleted) - Булево. Отобрать сообщения, которые должны быть удалены или не должны быть удалены; 
//     - УстановленФлаг (Flagged) - Булево. Отобрать сообщения, которые помечены флагом или не помечены флагом; 
//     - Прочитанные (Seen) - Булево. Отобрать сообщения, которые были прочитаны или не прочитаны; 
//     - Новые (New) - Булево. Отобрать новые или старые сообщения.
//
Функция ПолучитьВходящиеСообщения(
	Соединение,
	ПараметрыЗагрузки,
	СообщениеОбОшибке = Неопределено) Экспорт
	
	Попытка
		
		Если ПараметрыЗагрузки.ПолучитьЗаголовки Тогда
			НаборПисем = Соединение.ПолучитьЗаголовки(ПараметрыЗагрузки.ПараметрыОтбора);
		Иначе
			НаборПисем = Соединение.Выбрать(
				Ложь, // УдалятьСообщения
				ПараметрыЗагрузки.Идентификаторы);
		КонецЕсли;
		
	Исключение
		
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Почта.ЗаписатьОшибкуВЖурналРегистрации(СообщениеОбОшибке);
		
		Возврат Неопределено;
		
	КонецПопытки;
	
	Результат = Новый Массив;
	Для каждого Письмо Из НаборПисем Цикл
		Если Письмо.Частичное Тогда
			Продолжить;
		КонецЕсли;
		
		Сообщение = СформироватьСтруктуруПочтовогоСообщения();
		Для каждого ИнтернетПочтовыйАдрес Из Письмо.АдресаУведомленияОДоставке Цикл
			Сообщение.АдресаУведомленияОДоставке.Добавить(ПолучитьСтруктуруИнтернетПочтовогоАдреса(ИнтернетПочтовыйАдрес));
		КонецЦикла;
		Для каждого ИнтернетПочтовыйАдрес Из Письмо.АдресаУведомленияОПрочтении Цикл
			Сообщение.АдресаУведомленияОПрочтении.Добавить(ПолучитьСтруктуруИнтернетПочтовогоАдреса(ИнтернетПочтовыйАдрес));
		КонецЦикла;
		Сообщение.Важность = ПолучитьВажностьПисьмаИзВажностиИнтернетПочтовогоСообщения(Письмо.Важность);
		Сообщение.ДатаОтправки = Письмо.ДатаОтправления;
		Сообщение.ДатаПолучения = Письмо.ДатаПолучения;
		Сообщение.Заголовок = РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Письмо.Заголовок);
		Для каждого Идентификатор Из Письмо.Идентификатор Цикл
			Сообщение.Идентификатор.Добавить(РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Идентификатор));
		КонецЦикла;
		Сообщение.ИдентификаторСообщения = РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Письмо.ИдентификаторСообщения);
		Сообщение.ИмяОтправителя = РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Письмо.ИмяОтправителя);
		Сообщение.Категории = РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Письмо.Категории);
		Сообщение.Кодировка = РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Письмо.Кодировка);
		Для каждого ИнтернетПочтовыйАдрес Из Письмо.Копии Цикл
			Сообщение.Копии.Добавить(ПолучитьСтруктуруИнтернетПочтовогоАдреса(ИнтернетПочтовыйАдрес));
		КонецЦикла;
		Для каждого ИнтернетПочтовыйАдрес Из Письмо.ОбратныйАдрес Цикл
			Сообщение.ОбратныйАдрес.Добавить(ПолучитьСтруктуруИнтернетПочтовогоАдреса(ИнтернетПочтовыйАдрес));
		КонецЦикла;
		Сообщение.Организация = РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Письмо.Организация);
		Сообщение.Отправитель = ПолучитьСтруктуруИнтернетПочтовогоАдреса(Письмо.Отправитель);
		Для каждого ИнтернетПочтовыйАдрес Из Письмо.Получатели Цикл
			Сообщение.Получатели.Добавить(ПолучитьСтруктуруИнтернетПочтовогоАдреса(ИнтернетПочтовыйАдрес));
		КонецЦикла;
		Сообщение.Размер = ВычислитьРазмерИнтернетПочтовогоСообщения(Письмо);
		Для каждого ИнтернетПочтовыйАдрес Из Письмо.СлепыеКопии Цикл
			Сообщение.СлепыеКопии.Добавить(ПолучитьСтруктуруИнтернетПочтовогоАдреса(ИнтернетПочтовыйАдрес));
		КонецЦикла;
		Сообщение.СпособКодированияНеASCIIСимволов = Письмо.СпособКодированияНеASCIIСимволов;
		Для каждого ИнтернетТекстПочтовогоСообщения Из Письмо.Тексты Цикл
			Сообщение.Тексты.Добавить(ПолучитьСтруктуруИнтернетТекстаПочтовогоСообщения(ИнтернетТекстПочтовогоСообщения));
		КонецЦикла;
		Сообщение.Тема = РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Письмо.Тема);
		Сообщение.УведомитьОДоставке = Письмо.УведомитьОДоставке;
		Сообщение.УведомитьОПрочтении = Письмо.УведомитьОПрочтении;
		Сообщение.Частичное = Письмо.Частичное;
		
		Если Не ПараметрыЗагрузки.ПолучитьЗаголовки Тогда
			Для каждого ИнтернетПочтовоеВложение Из Письмо.Вложения Цикл
				Если ТипЗнч(ИнтернетПочтовоеВложение.Данные) <> Тип("ДвоичныеДанные") Тогда
					Продолжить;
				КонецЕсли;
				Сообщение.Вложения.Добавить(ПолучитьСтруктуруИнтернетПочтовогоВложения(ИнтернетПочтовоеВложение));
			КонецЦикла;
		КонецЕсли;
		
		Сообщение.ПоляЗаголовка.Добавить(
			ПолучитьСтруктуруПоляЗаголовкаПочтовогоСообщения(
				Письмо, "In-Reply-To", "Строка"));
		
		Сообщение.ПоляЗаголовка.Добавить(
			ПолучитьСтруктуруПоляЗаголовкаПочтовогоСообщения(
				Письмо, "References", "Строка"));
		
		Результат.Добавить(Сообщение);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Удаляет сообщения в почтовом ящике.
//
// Параметры:
// - Соединение (ИнтернетПочта)
// - Идентификаторы (Массив) массив идентификаторов удаляемых сообщений
// - СообщениеОбОшибке (Строка) - необязательный
//
Функция УдалитьСообщенияВПочтовомЯщике(
	Соединение,
	Идентификаторы,
	СообщениеОбОшибке = Неопределено) Экспорт
	
	Попытка
		
		Соединение.УдалитьСообщения(Идентификаторы);
		
	Исключение
		
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьОшибкуВЖурналРегистрации(СообщениеОбОшибке);
		
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// Отправляет сообщение через открытое соединение.
//
Функция ОтправитьСообщение(
	Соединение,
	ПараметрыОтправки,
	СообщениеОбОшибке = Неопределено) Экспорт
	
	Попытка
	
		ИнтернетПочтовоеСообщение = Новый ИнтернетПочтовоеСообщение;
		
		Для каждого СтруктураПочтовогоАдреса Из ПараметрыОтправки.АдресаУведомленияОДоставке Цикл
			ИнтернетПочтовыеАдресаДобавитьПочтовыйАдрес(
				ИнтернетПочтовоеСообщение.АдресаУведомленияОДоставке,
				СтруктураПочтовогоАдреса);
		КонецЦикла;
		
		Для каждого СтруктураПочтовогоАдреса Из ПараметрыОтправки.АдресаУведомленияОПрочтении Цикл
			ИнтернетПочтовыеАдресаДобавитьПочтовыйАдрес(
				ИнтернетПочтовоеСообщение.АдресаУведомленияОПрочтении,
				СтруктураПочтовогоАдреса);
		КонецЦикла;
		
		Если ПараметрыОтправки.Свойство("Важность")
			И ЗначениеЗаполнено(ПараметрыОтправки.Важность) Тогда
			ИнтернетПочтовоеСообщение.Важность = ПолучитьВажностьИнтернетПочтовогоСообщенияИзВажностиПисьма(
				ПараметрыОтправки.Важность);
		КонецЕсли;
		
		Для каждого СтруктураВложения Из ПараметрыОтправки.Вложения Цикл
			ИнтернетПочтовоеСообщениеДобавитьВложение(
				ИнтернетПочтовоеСообщение,
				СтруктураВложения);
		КонецЦикла;
		
		Если ПараметрыОтправки.Свойство("ИмяОтправителя")
			И ЗначениеЗаполнено(ПараметрыОтправки.ИмяОтправителя) Тогда
			ИнтернетПочтовоеСообщение.ИмяОтправителя = ПараметрыОтправки.ИмяОтправителя;
		КонецЕсли;
		
		Если ПараметрыОтправки.Свойство("Кодировка")
			И ЗначениеЗаполнено(ПараметрыОтправки.Кодировка) Тогда
			ИнтернетПочтовоеСообщение.Кодировка = ПараметрыОтправки.Кодировка;
		КонецЕсли;
		
		Для каждого СтруктураПочтовогоАдреса Из ПараметрыОтправки.Копии Цикл
			ИнтернетПочтовыеАдресаДобавитьПочтовыйАдрес(
				ИнтернетПочтовоеСообщение.Копии,
				СтруктураПочтовогоАдреса);
		КонецЦикла;
		
		Для каждого СтруктураПочтовогоАдреса Из ПараметрыОтправки.ОбратныйАдрес Цикл
			ИнтернетПочтовыеАдресаДобавитьПочтовыйАдрес(
				ИнтернетПочтовоеСообщение.ОбратныйАдрес,
				СтруктураПочтовогоАдреса);
		КонецЦикла;
		
		Если ПараметрыОтправки.Свойство("Отправитель")
			И ЗначениеЗаполнено(ПараметрыОтправки.Отправитель) Тогда
			ЗаполнитьИнтернетПочтовыйАдресИзСтруктурыПочтовогоАдреса(
				ИнтернетПочтовоеСообщение.Отправитель,
				ПараметрыОтправки.Отправитель);
		КонецЕсли;
		
		Для каждого СтруктураПочтовогоАдреса Из ПараметрыОтправки.Получатели Цикл
			ИнтернетПочтовыеАдресаДобавитьПочтовыйАдрес(
				ИнтернетПочтовоеСообщение.Получатели,
				СтруктураПочтовогоАдреса);
		КонецЦикла;
		
		Для каждого СтруктураПочтовогоАдреса Из ПараметрыОтправки.СлепыеКопии Цикл
			ИнтернетПочтовыеАдресаДобавитьПочтовыйАдрес(
				ИнтернетПочтовоеСообщение.СлепыеКопии,
				СтруктураПочтовогоАдреса);
		КонецЦикла;
		
		Если ПараметрыОтправки.Свойство("СпособКодированияНеASCIIСимволов")
			И ЗначениеЗаполнено(ПараметрыОтправки.СпособКодированияНеASCIIСимволов) Тогда
			ИнтернетПочтовоеСообщение.СпособКодированияНеASCIIСимволов =
				ПараметрыОтправки.СпособКодированияНеASCIIСимволов;
		КонецЕсли;
		
		Для каждого СтруктураТекста Из ПараметрыОтправки.Тексты Цикл
			ИнтернетПочтовоеСообщениеДобавитьТекст(
				ИнтернетПочтовоеСообщение,
				СтруктураТекста);
		КонецЦикла;
		
		ИнтернетПочтовоеСообщение.Тема = ПараметрыОтправки.Тема;
		
		Если ПараметрыОтправки.Свойство("УведомитьОДоставке")
			И ЗначениеЗаполнено(ПараметрыОтправки.УведомитьОДоставке) Тогда
			ИнтернетПочтовоеСообщение.УведомитьОДоставке = ПараметрыОтправки.УведомитьОДоставке;
		КонецЕсли;
		
		Если ПараметрыОтправки.Свойство("УведомитьОПрочтении")
			И ЗначениеЗаполнено(ПараметрыОтправки.УведомитьОПрочтении) Тогда
			ИнтернетПочтовоеСообщение.УведомитьОПрочтении = ПараметрыОтправки.УведомитьОПрочтении;
		КонецЕсли;
		
		Для каждого ПолеЗаголовка Из ПараметрыОтправки.ПоляЗаголовка Цикл
			ИнтернетПочтовоеСообщение.УстановитьПолеЗаголовка(
				ПолеЗаголовка.ИмяПоля,
				ПолеЗаголовка.ЗначениеПоля,
				ПолеЗаголовка.СпособКодирования);
		КонецЦикла;
		
		Размер = ВычислитьРазмерИнтернетПочтовогоСообщения(ИнтернетПочтовоеСообщение);
		
		//Соединение.Послать(ИнтернетПочтовоеСообщение);
		
		Попытка
			МассивФайловКартинок = Новый Массив();
			
			Для Каждого Текст Из ИнтернетПочтовоеСообщение.Тексты Цикл
				Если Текст.ТипТекста = ТипТекстаПочтовогоСообщения.HTML Тогда
					
				КонецЕсли;	
			КонецЦикла;	
			// если есть битые ссылки на картинки, не прерывать отправку		
			ИнтернетПочтовоеСообщение.ОбработатьТексты();
		Исключение
		КонецПопытки;
		Соединение.Послать(ИнтернетПочтовоеСообщение, ОбработкаТекстаИнтернетПочтовогоСообщения.НеОбрабатывать);
		
		ПараметрыОтправки.Вставить("ИдентификаторСообщения", ИнтернетПочтовоеСообщение.ИдентификаторСообщения);
		ПараметрыОтправки.Вставить("Размер", Размер);
		
	Исключение
		
		СообщениеОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписатьОшибкуВЖурналРегистрации(СообщениеОбОшибке);
		
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ВычислитьРазмерИнтернетПочтовогоСообщения(ИнтернетПочтовоеСообщение)
	
	Размер = 0;
	
	Размер = Размер + СтрДлина(ИнтернетПочтовоеСообщение.Тема);
	Для каждого Текст Из ИнтернетПочтовоеСообщение.Тексты Цикл
		Размер = Размер + СтрДлина(Текст.Текст);
	КонецЦикла;
	Для каждого Вложение Из ИнтернетПочтовоеСообщение.Вложения Цикл
		Если ТипЗнч(Вложение.Данные) <> Тип("ДвоичныеДанные") Тогда
			Продолжить;
		КонецЕсли;
		Размер = Размер + Вложение.Данные.Размер();
	КонецЦикла;
	
	Возврат Размер;
	
КонецФункции


/////////////////////////////////////////////////////////////////////////////////////////
// РАБОТА С ИНТЕРНЕТ ПОЧТОВЫМ СООБЩЕНИЕМ

// Добавляет почтовый адрес в коллекцию интернет почтовых адресов.
//
Процедура ИнтернетПочтовыеАдресаДобавитьПочтовыйАдрес(
	ИнтернетПочтовыеАдреса,
	СтруктураПочтовогоАдреса)
	
	ИнтернетПочтовыйАдрес = ИнтернетПочтовыеАдреса.Добавить();
	
	ЗаполнитьИнтернетПочтовыйАдресИзСтруктурыПочтовогоАдреса(
		ИнтернетПочтовыйАдрес,
		СтруктураПочтовогоАдреса)
	
КонецПроцедуры

// Добавляет вложение в интернет почтовое сообщение.
//
Процедура ИнтернетПочтовоеСообщениеДобавитьВложение(
	ИнтернетПочтовоеСообщение,
	СтруктураВложения) Экспорт
	
	Наименование = Неопределено;
	Если СтруктураВложения.Свойство("Наименование")
		И ЗначениеЗаполнено(СтруктураВложения.Наименование) Тогда
		Наименование = СтруктураВложения.Наименование;
	КонецЕсли;
	
	Если ТипЗнч(СтруктураВложения.Данные) = Тип("Строка")
		И ЭтоАдресВременногоХранилища(СтруктураВложения.Данные) Тогда
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(СтруктураВложения.Данные);
		ИнтернетПочтовоеСообщение.Вложения.Добавить(
			ДвоичныеДанные,
			Наименование);
	ИначеЕсли ТипЗнч(СтруктураВложения.Данные) = Тип("ДвоичныеДанные") Тогда
		ИнтернетПочтовоеСообщение.Вложения.Добавить(
			СтруктураВложения.Данные,
			Наименование);
	ИначеЕсли ТипЗнч(СтруктураВложения.Данные) = Тип("ИнтернетПочтовоеСообщение") Тогда
		ИнтернетПочтовоеСообщение.Вложения.Добавить(
			СтруктураВложения.Данные,
			Наименование);
	Иначе
		ВызватьИсключение НСтр("ru = 'Указаны некорректные данные вложения'");
	КонецЕсли;
	
КонецПроцедуры

// Добавляет текст в интернет почтовое сообщение.
//
Процедура ИнтернетПочтовоеСообщениеДобавитьТекст(ИнтернетПочтовоеСообщение, СтруктураТекста) Экспорт
	
	ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст;
	Если СтруктураТекста.Свойство("ТипТекста")
		И ЗначениеЗаполнено(СтруктураТекста.ТипТекста) Тогда
		ТипТекста = СтруктураТекста.ТипТекста;
	КонецЕсли;
	
	Текст = СтруктураТекста.Текст;
	РаботаСоСтроками.ДобавитьВК(Текст);
	
	ИнтернетТекстПочтовогоСообщения = ИнтернетПочтовоеСообщение.Тексты.Добавить(
		Текст,
		ПолучитьТипТекстаПочтовогоСообщенияДляИнтернетПочтовогоСообщения(ТипТекста));
	Если ЗначениеЗаполнено(СтруктураТекста.Кодировка) Тогда
		ИнтернетТекстПочтовогоСообщения.Кодировка = СтруктураТекста.Кодировка;
	КонецЕсли;
	
КонецПроцедуры


/////////////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ ДЛЯ РАБОТЫ С ИНТЕРНЕТ ПОЧТОВЫМ СООБЩЕНИЕМ

// Возвращает структуру параметров загрузки.
//
Функция СформироватьСтруктуруПараметровЗагрузки() Экспорт
	
	ПараметрыЗагрузки = Новый Структура;
	ПараметрыЗагрузки.Вставить("Идентификаторы", Новый Массив);
	ПараметрыЗагрузки.Вставить("ПолучитьЗаголовки", Ложь);
	ПараметрыЗагрузки.Вставить("ПараметрыОтбора", Новый Структура);
	
	Возврат ПараметрыЗагрузки;
	
КонецФункции

// Возвращает структуру параметров отправки.
//
Функция СформироватьСтруктуруПараметровОтправки() Экспорт
	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("АдресаУведомленияОДоставке", Новый Массив);
	ПараметрыОтправки.Вставить("АдресаУведомленияОПрочтении", Новый Массив);
	ПараметрыОтправки.Вставить("Важность", Перечисления.ВажностьПисем.Обычная);
	ПараметрыОтправки.Вставить("Вложения", Новый Массив);
	ПараметрыОтправки.Вставить("ИмяОтправителя", "");
	ПараметрыОтправки.Вставить("Кодировка", "");
	ПараметрыОтправки.Вставить("Копии", Новый Массив);
	ПараметрыОтправки.Вставить("ОбратныйАдрес", Новый Массив);
	ПараметрыОтправки.Вставить("Отправитель", Неопределено);
	ПараметрыОтправки.Вставить("Получатели", Новый Массив);
	ПараметрыОтправки.Вставить("СлепыеКопии", Новый Массив);
	ПараметрыОтправки.Вставить("СпособКодированияНеASCIIСимволов", 0);
	ПараметрыОтправки.Вставить("Тексты", Новый Массив);
	ПараметрыОтправки.Вставить("Тема", "");
	ПараметрыОтправки.Вставить("УведомитьОДоставке", Ложь);
	ПараметрыОтправки.Вставить("УведомитьОПрочтении", Ложь);
	ПараметрыОтправки.Вставить("ПоляЗаголовка", Новый Массив);
	
	Возврат ПараметрыОтправки;
	
КонецФункции

// Возвращает структуру (Адрес, ОтображаемоеИмя)
//
Функция СформироватьСтруктуруПочтовогоАдреса(Адрес, ОтображаемоеИмя) Экспорт
	
	Возврат Новый Структура("Адрес, ОтображаемоеИмя", Адрес, ОтображаемоеИмя);
	
КонецФункции

// Возвращает структуру текста почтового сообщения.
//
Функция СформироватьСтруктуруТекстаПочтовогоСообщения(ТипТекста, Текст, Кодировка) Экспорт
	
	Возврат Новый Структура("ТипТекста, Текст, Кодировка", ТипТекста, Текст, Кодировка);
	
КонецФункции

// Возвращает структуру из интернет-почтового адреса.
//
Функция ПолучитьСтруктуруИнтернетПочтовогоАдреса(ИнтернетПочтовыйАдрес) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Адрес", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(ИнтернетПочтовыйАдрес.Адрес));
	Результат.Вставить("Кодировка", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(ИнтернетПочтовыйАдрес.Кодировка));
	Результат.Вставить("ОтображаемоеИмя", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(ИнтернетПочтовыйАдрес.ОтображаемоеИмя));
	Результат.Вставить("Пользователь", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(ИнтернетПочтовыйАдрес.Пользователь));
	Результат.Вставить("Сервер", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(ИнтернетПочтовыйАдрес.Сервер));
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру из интернет-почтового вложения.
//
Функция ПолучитьСтруктуруИнтернетПочтовогоВложения(ИнтернетПочтовоеВложение) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Данные", ИнтернетПочтовоеВложение.Данные);
	Результат.Вставить("Идентификатор", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(ИнтернетПочтовоеВложение.Идентификатор));
	Результат.Вставить("Имя", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(ИнтернетПочтовоеВложение.Имя));
	Результат.Вставить("ИмяФайла", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(ИнтернетПочтовоеВложение.ИмяФайла));
	Результат.Вставить("Кодировка", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(ИнтернетПочтовоеВложение.Кодировка));
	Результат.Вставить("СпособКодирования", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(Строка(ИнтернетПочтовоеВложение.СпособКодирования)));
	Результат.Вставить("ТипСодержимого", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(ИнтернетПочтовоеВложение.ТипСодержимого));
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру из интернет-текста почтового сообщения.
//
Функция ПолучитьСтруктуруИнтернетТекстаПочтовогоСообщения(ИнтернетТекстПочтовогоСообщения) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Данные", ИнтернетТекстПочтовогоСообщения.Данные);
	Результат.Вставить("Кодировка", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(ИнтернетТекстПочтовогоСообщения.Кодировка));
	Результат.Вставить("Текст", РаботаСоСтроками.УдалитьНедопустимыеСимволыXML(ИнтернетТекстПочтовогоСообщения.Текст));
	Результат.Вставить("ТипТекста", ПолучитьТипТекстаПочтовогоСообщенияДляСтруктуры(ИнтернетТекстПочтовогоСообщения.ТипТекста));
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру поля заголовка интернет-почтового сообщения.
//
Функция ПолучитьСтруктуруПоляЗаголовкаПочтовогоСообщения(Письмо, ИмяПоля, Тип) Экспорт
	
	ЗначениеПоля = Письмо.ПолучитьПолеЗаголовка(ИмяПоля, Тип);
	Если ТипЗнч(ЗначениеПоля) = Тип("Строка")
		И Найти(ЗначениеПоля, ":") = 1 Тогда
		ЗначениеПоля = СокрЛП(Сред(ЗначениеПоля ,2));
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Имя", ИмяПоля);
	Результат.Вставить("Значение", ЗначениеПоля);
	
	Возврат Результат;
	
КонецФункции

// Заполняет интернет-почтовый адрес из структуры.
//
Процедура ЗаполнитьИнтернетПочтовыйАдресИзСтруктурыПочтовогоАдреса(
	ИнтернетПочтовыйАдрес,
	СтруктураПочтовогоАдреса) Экспорт
	
	Если СтруктураПочтовогоАдреса.Свойство("Адрес")
		И ЗначениеЗаполнено(СтруктураПочтовогоАдреса.Адрес) Тогда
		ИнтернетПочтовыйАдрес.Адрес = СтруктураПочтовогоАдреса.Адрес;
	КонецЕсли;
	Если СтруктураПочтовогоАдреса.Свойство("Кодировка")
		И ЗначениеЗаполнено(СтруктураПочтовогоАдреса.Кодировка) Тогда
		ИнтернетПочтовыйАдрес.Кодировка = СтруктураПочтовогоАдреса.Кодировка;
	КонецЕсли;
	Если СтруктураПочтовогоАдреса.Свойство("ОтображаемоеИмя")
		И ЗначениеЗаполнено(СтруктураПочтовогоАдреса.ОтображаемоеИмя) Тогда
		ИнтернетПочтовыйАдрес.ОтображаемоеИмя = СтруктураПочтовогоАдреса.ОтображаемоеИмя;
	КонецЕсли;
	Если СтруктураПочтовогоАдреса.Свойство("Пользователь")
		И ЗначениеЗаполнено(СтруктураПочтовогоАдреса.Пользователь) Тогда
		ИнтернетПочтовыйАдрес.Пользователь = СтруктураПочтовогоАдреса.Пользователь;
	КонецЕсли;
	
КонецПроцедуры

// Преобразует значение перечисления ТипыТекстовПочтовыхСообщений
// в значение предопределенного перечисления ТипТекстаПочтовогоСообщения.
//
Функция ПолучитьТипТекстаПочтовогоСообщенияДляИнтернетПочтовогоСообщения(ТипТекста) Экспорт
	
	Если ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.HTML Тогда
		Возврат ТипТекстаПочтовогоСообщения.HTML;
	ИначеЕсли ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.РазмеченныйТекст Тогда
		Возврат ТипТекстаПочтовогоСообщения.РазмеченныйТекст;
	Иначе
		Возврат ТипТекстаПочтовогоСообщения.ПростойТекст;
	КонецЕсли;
	
КонецФункции

// Преобразует значение предопределенного перечисления ТипТекстаПочтовогоСообщения
// в значение перечисления ТипыТекстовПочтовыхСообщений.
//
Функция ПолучитьТипТекстаПочтовогоСообщенияДляСтруктуры(ТипТекста) Экспорт
	
	Если ТипТекста = ТипТекстаПочтовогоСообщения.HTML Тогда
		Возврат Перечисления.ТипыТекстовПочтовыхСообщений.HTML;
	ИначеЕсли ТипТекста = ТипТекстаПочтовогоСообщения.РазмеченныйТекст Тогда
		Возврат Перечисления.ТипыТекстовПочтовыхСообщений.РазмеченныйТекст;
	Иначе
		Возврат Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст;
	КонецЕсли;
	
КонецФункции

// Возвращает перечисление ВажностьПисем из важности интернет-почтового сообщения.
//
Функция ПолучитьВажностьПисьмаИзВажностиИнтернетПочтовогоСообщения(Важность) Экспорт
	
	Если Важность = ВажностьИнтернетПочтовогоСообщения.Высокая
		Или Важность = ВажностьИнтернетПочтовогоСообщения.Наивысшая Тогда
		Возврат Перечисления.ВажностьПисем.Высокая;
	ИначеЕсли Важность = ВажностьИнтернетПочтовогоСообщения.Низкая
		Или Важность = ВажностьИнтернетПочтовогоСообщения.Наименьшая Тогда
		Возврат Перечисления.ВажностьПисем.Низкая;
	Иначе
		Возврат Перечисления.ВажностьПисем.Обычная;
	КонецЕсли;
	
КонецФункции

// Возвращает важность интернет-почтового сообщения из перечисления ВажностьПисем.
//
Функция ПолучитьВажностьИнтернетПочтовогоСообщенияИзВажностиПисьма(Важность) Экспорт
	
	Если Важность = Перечисления.ВажностьПисем.Высокая Тогда
		Возврат ВажностьИнтернетПочтовогоСообщения.Высокая;
	ИначеЕсли Важность = Перечисления.ВажностьПисем.Низкая Тогда
		Возврат ВажностьИнтернетПочтовогоСообщения.Низкая;
	Иначе
		Возврат ВажностьИнтернетПочтовогоСообщения.Обычная;
	КонецЕсли;
	
КонецФункции


/////////////////////////////////////////////////////////////////////////////////////////
// РАБОТА СО СТРУКТУРОЙ ПОЧТОВОГО СООБЩЕНИЯ

// Возвращает новую структуру почтового сообщения.
//
Функция СформироватьСтруктуруПочтовогоСообщения() Экспорт
	
	Сообщение = Новый Структура;
	
	Сообщение.Вставить("АдресаУведомленияОДоставке", Новый Массив);
	Сообщение.Вставить("АдресаУведомленияОПрочтении", Новый Массив);
	Сообщение.Вставить("Важность", Перечисления.ВажностьПисем.Обычная);
	Сообщение.Вставить("Вложения", Новый Массив);
	Сообщение.Вставить("ДатаОтправки", Дата(1,1,1));
	Сообщение.Вставить("ДатаПолучения", Дата(1,1,1));
	Сообщение.Вставить("Заголовок", "");
	Сообщение.Вставить("Идентификатор", Новый Массив);
	Сообщение.Вставить("ИдентификаторСообщения", "");
	Сообщение.Вставить("ИмяОтправителя", "");
	Сообщение.Вставить("Категории", "");
	Сообщение.Вставить("Кодировка", "");
	Сообщение.Вставить("Копии", Новый Массив);
	Сообщение.Вставить("ОбратныйАдрес", Новый Массив);
	Сообщение.Вставить("Организация", "");
	Сообщение.Вставить("Отправитель", Неопределено);
	Сообщение.Вставить("Получатели", Новый Массив);
	Сообщение.Вставить("Размер", 0);
	Сообщение.Вставить("СлепыеКопии", Новый Массив);
	Сообщение.Вставить("СпособКодированияНеASCIIСимволов", 0);
	Сообщение.Вставить("Тексты", Новый Массив);
	Сообщение.Вставить("Тема", "");
	Сообщение.Вставить("УведомитьОДоставке", Ложь);
	Сообщение.Вставить("УведомитьОПрочтении", Ложь);
	Сообщение.Вставить("Частичное", Ложь);
	Сообщение.Вставить("ПоляЗаголовка", Новый Массив);
	
	Возврат Сообщение;
	
КонецФункции

// Формирует структуру поля заголовка.
//
Функция СформироватьСтруктуруПоляЗаголовка(ИмяПоля, ЗначениеПоля, СпособКодирования = Неопределено) Экспорт
	
	Возврат Новый Структура(
		"ИмяПоля, ЗначениеПоля, СпособКодирования",
		ИмяПоля,
		ЗначениеПоля,
		СпособКодирования);
	
КонецФункции

// Возвращает значение указанного поля почтового сообщения.
//
Функция ПолучитьПолеЗаголовкаИзСтруктурыПочтовогоСообщения(СтруктураСообщения, ИмяПоля) Экспорт
	
	Для каждого Поле Из СтруктураСообщения.ПоляЗаголовка Цикл
		Если Поле.Имя = ИмяПоля Тогда
			Возврат Поле.Значение;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
	
КонецФункции

// Возвращает структуру текста из структуры почтового сообщения.
//
Функция ПолучитьСтруктуруТекстаИзСтруктурыПочтовогоСообщения(Сообщение) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ТипТекста", Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст);
	Результат.Вставить("Текст", "");
	Результат.Вставить("ТекстHTML", "");
	Результат.Вставить("Кодировка", "");
	
	ТекстHTML = "";
	ТекстПростой = "";
	ТекстРазмеченный = "";
	Кодировка = "";
	
	Для каждого ТекстПочтовогоСообщения Из Сообщение.Тексты Цикл
		Текст = ТекстПочтовогоСообщения.Текст;
		ТипТекста = ТекстПочтовогоСообщения.ТипТекста;
		Если ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.HTML Тогда
			ТекстHTML = Текст;
			Кодировка = ТекстПочтовогоСообщения.Кодировка;
		ИначеЕсли ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.РазмеченныйТекст Тогда
			ТекстРазмеченный = Текст;
			Кодировка = ТекстПочтовогоСообщения.Кодировка;
		ИначеЕсли ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст Тогда
			ТекстПростой = Текст;
			Если Не ЗначениеЗаполнено(Кодировка) Тогда
				Кодировка = ТекстПочтовогоСообщения.Кодировка;
			КонецЕсли;
		Иначе
			ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст;
			ТекстПростой = Текст;
			Если Не ЗначениеЗаполнено(Кодировка) Тогда
				Кодировка = ТекстПочтовогоСообщения.Кодировка;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ПустаяСтрока(ТекстHTML) Тогда
		РаботаСHTML.ДобавитьНеобходимыеТэгиHTML(ТекстHTML);
		Результат.ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.HTML;
		Результат.ТекстHTML = ТекстHTML;
		Если ПустаяСтрока(ТекстПростой) Тогда
			Результат.Текст = РаботаСHTML.ПолучитьПростойТекстИзHTML(ТекстHTML, Кодировка);
		Иначе
			Результат.Текст = ТекстПростой;
		КонецЕсли;
	ИначеЕсли Не ПустаяСтрока(ТекстРазмеченный) Тогда
		Результат.ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.РазмеченныйТекст;
		Результат.Текст = ТекстРазмеченный;
	Иначе
		Результат.ТипТекста = Перечисления.ТипыТекстовПочтовыхСообщений.ПростойТекст;
		Результат.Текст = ТекстПростой;
	КонецЕсли;
	
	Результат.Кодировка = Кодировка;
	
	Возврат Результат;
	
КонецФункции
