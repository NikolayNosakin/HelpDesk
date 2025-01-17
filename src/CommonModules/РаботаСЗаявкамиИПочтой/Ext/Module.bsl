﻿
Процедура ОбработатьВходящееПисьмо(ПисьмоСсылка) Экспорт 
	Если ПисьмоСсылка.УчетнаяЗапись.АвтоматическиСоздаватьЗаявки = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	Если ПисьмоСсылка.Тема = "Тестовое письмо (1С:Поддержка пользователей)" Тогда
		Возврат;               //Тестовое письмо не обрабатываем
	КонецЕсли;
	
	Если Нрег(ПисьмоСсылка.ОтправительАдрес) = Нрег(ПисьмоСсылка.УчетнаяЗапись.АдресЭлектроннойПочты) Тогда
		Возврат;               //Письма от самих себя не обрабатываем
	КонецЕсли;

	//Определим есть ли в письме указание на заячку (в случае ответа на письмо)
	Заявка = ОпределитьЗаявкуОснованиеПоПисьму(ПисьмоСсылка);	
	
	Если значениеЗаполнено(Заявка) Тогда 
		//Проверим нашу заявку
		Если Заявка.Статус = Справочники.СостоянияЗаявок.Отменена 
			ИЛИ (Заявка.Статус = Справочники.СостоянияЗаявок.Объединена И не ЗначениеЗаполнено(Заявка.ГлавнаяЗаявка)) Тогда
			
			МенеджерЗаписи = РегистрыСведений.ОповещенияПоЗаявкам.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Заявка = Заявка;
			МенеджерЗаписи.УчетнаяЗапись = ?(ЗначениеЗаполнено(Заявка.Контрагент.УчетнаяЗаписьДляОповещений),Заявка.Контрагент.УчетнаяЗаписьДляОповещений,ВстроеннаяПочтаСервер.ПолучитьУчетнуюЗаписьДляОтправки());
			МенеджерЗаписи.Событие = Перечисления.ВидыСобытийПоЗаявке.ОшибкаРегистрации;
			МенеджерЗаписи.ДатаСобытия = ТекущаяДата();
			
			МенеджерЗаписи.Записать();
		ИначеЕсли Заявка.Статус = Справочники.СостоянияЗаявок.Объединена Тогда
			ДобавитьОтветКЗаявке(ПисьмоСсылка,Заявка.ГлавнаяЗаявка);
		Иначе	
			ДобавитьОтветКЗаявке(ПисьмоСсылка,Заявка);
		КонецЕсли;
	Иначе
		// Сформируем новую заявку
		Заявка = Документы.Заявка.СоздатьДокумент();
		Заявка.ТекущийИсполнитель = Справочники.Пользователи.РаспределительЗаявок;
		Заявка.Заполнить(ПисьмоСсылка);
		Заявка.Записать();		
		  		  
		// оповестим о регистрации заявки в системе	
		МенеджерЗаписи = РегистрыСведений.ОповещенияПоЗаявкам.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Заявка = Заявка.Ссылка;
		МенеджерЗаписи.УчетнаяЗапись = ?(ЗначениеЗаполнено(Заявка.Контрагент.УчетнаяЗаписьДляОповещений),Заявка.Контрагент.УчетнаяЗаписьДляОповещений,ВстроеннаяПочтаСервер.ПолучитьУчетнуюЗаписьДляОтправки());
		МенеджерЗаписи.Событие = Перечисления.ВидыСобытийПоЗаявке.Зарегистрирована;
		МенеджерЗаписи.ДатаСобытия = ТекущаяДата();
		
		МенеджерЗаписи.Записать();
	КонецЕсли;
	
	ОбработатьНеОтвеченныеСобытияОповещения(Заявка.Ссылка);
КонецПроцедуры // ОбработатьВходящееПисьмо()

Функция НайтиСоздатьПользователяПоАдресуОтправителя(ОтправительАдрес) Экспорт 
	СтруктураОтправителя = РаботаСоСтроками.РазложитьАдресЭлектроннойПочты(ОтправительАдрес);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПользователиКонтактнаяИнформация.Ссылка
		|ИЗ
		|	Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
		|ГДЕ
		|	ПользователиКонтактнаяИнформация.АдресЭП = &АдресЭП";
	
	Запрос.УстановитьПараметр("АдресЭП", СокрЛП(СтруктураОтправителя.Адрес));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда 
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;

	// не нашли пользователя
	
	ПользовательОбъект = Справочники.Пользователи.СоздатьЭлемент();
	ПользовательОбъект.Наименование	= СтруктураОтправителя.Пользователь;
	
	НовыйАдрес = ПользовательОбъект.КонтактнаяИнформация.Добавить();
	НовыйАдрес.АдресЭП				= СокрЛП(СтруктураОтправителя.Адрес);
	НовыйАдрес.ДоменноеИмяСервера	= СтруктураОтправителя.Домен;
	НовыйАдрес.Представление		= СтруктураОтправителя.Представление;
	
	Если Не ЗначениеЗаполнено(НовыйАдрес.Представление) Тогда
		НовыйАдрес.Представление = СокрЛП(СтруктураОтправителя.Адрес);
	КонецЕсли;
	
	НовыйАдрес.Вид					= Справочники.ВидыКонтактнойИнформации.EmailПользователя;
	НовыйАдрес.Тип					= Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
		
	ПользовательОбъект.Недействителен = Ложь;

	//Информация по домену пользователя
	Если ЗначениеЗаполнено(СтруктураОтправителя.Домен) Тогда
		СтрокиДомен = ПользовательОбъект.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Вид", Справочники.ВидыКонтактнойИнформации.ДоменноеИмяПользователя));
		Если СтрокиДомен.Количество() > 0 Тогда
			СтрокаДомен = СтрокиДомен[0];
		Иначе
			СтрокаДомен = ПользовательОбъект.КонтактнаяИнформация.Добавить();
			СтрокаДомен.Вид = Справочники.ВидыКонтактнойИнформации.ДоменноеИмяПользователя;
		КонецЕсли;
		СтрокаДомен.Тип = Перечисления.ТипыКонтактнойИнформации.Другое;
		СтрокаДомен.Представление = СтруктураОтправителя.Пользователь;
		
		АккаунтОС = "\\" + СтруктураОтправителя.Домен + "\" + СтруктураОтправителя.Пользователь;
		
		ОписаниеПользователяИБ = Пользователи.НовоеОписаниеПользователяИБ();
		
		ОписаниеПользователяИБ.Имя =СтруктураОтправителя.Пользователь;
		ОписаниеПользователяИБ.ПолноеИмя = СтруктураОтправителя.Пользователь;
		ОписаниеПользователяИБ.АутентификацияСтандартная = Ложь;
		ОписаниеПользователяИБ.АутентификацияOpenID = Ложь;
		ОписаниеПользователяИБ.АутентификацияОС = Истина;
		ОписаниеПользователяИБ.ПользовательОС = АккаунтОС;
		ОписаниеПользователяИБ.ПоказыватьВСпискеВыбора = Ложь;
		ОписаниеПользователяИБ.ЗапрещеноИзменятьПароль = Истина;
		ОписаниеПользователяИБ.РежимЗапуска = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение;
		ОписаниеПользователяИБ.Вставить("Действие", "Записать");
		
		ПользовательОбъект.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
		
	КонецЕсли;
	
	ПользовательОбъект.Записать();
	
	ПрофильНовогоПользователяПоУмолчанию = Константы.ПрофильНовогоПользователяПоУмолчанию.Получить();
	Если ЗначениеЗаполнено(ПрофильНовогоПользователяПоУмолчанию) Тогда
		ТаблицаПрофилей = Новый ТаблицаЗначений();
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("СправочникСсылка.ПрофилиГруппДоступа"));
		ОписаниеТиповПрофили = Новый ОписаниеТипов(МассивТипов);
		МассивТипов.Очистить();
		МассивТипов.Добавить(Тип("Булево"));
		ОписаниеТиповБ = Новый ОписаниеТипов(МассивТипов);
		ТаблицаПрофилей.Колонки.Добавить("Профиль",ОписаниеТиповПрофили);
		ТаблицаПрофилей.Колонки.Добавить("Пометка",ОписаниеТиповБ);
		
		НовСтр = ТаблицаПрофилей.Добавить();
		НовСтр.Пометка = Истина;
		НовСтр.Профиль = ПрофильНовогоПользователяПоУмолчанию;

		ОбновитьПраваПользователя(ПользовательОбъект.Ссылка,ТаблицаПрофилей);
	КонецЕсли;

	Возврат ПользовательОбъект.Ссылка;
	
КонецФункции // НайтиСоздатьПользователяПоАдресуОтправителя()

Функция НайтиКонтрагентаПоАдресуОтправителя(ОтправительАдрес) Экспорт 
	Возврат Справочники.Контрагенты.НашаОрганизация;	
КонецФункции // НайтиСоздатьПользователяПоАдресуОтправителя()

Процедура РассылкаОповещенийПоЗаявкам() Экспорт
	ОбработатьНеОтвеченныеСобытияОповещения();
КонецПроцедуры

Процедура ОбработатьНеОтвеченныеСобытияОповещения(Заявка=Неопределено) 		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОповещенияПоЗаявкам.УчетнаяЗапись,
		|	ОповещенияПоЗаявкам.Заявка,
		|	ОповещенияПоЗаявкам.Событие,
		|	ОповещенияПоЗаявкам.ИдСобытия,
		|	ОповещенияПоЗаявкам.ДатаСобытия
		|ИЗ
		|	РегистрСведений.ОповещенияПоЗаявкам КАК ОповещенияПоЗаявкам
		|ГДЕ
		|	ОповещенияПоЗаявкам.ПисьмоОтправлено = Ложь
		|	И ВЫБОР
		|			КОГДА &ЗаявкаЗаполнена = ИСТИНА
		|				ТОГДА ОповещенияПоЗаявкам.Заявка = &Заявка
		|			ИНАЧЕ Истина
		|		КОНЕЦ";
	Запрос.УстановитьПараметр("Заявка",Заявка);
	Запрос.УстановитьПараметр("ЗаявкаЗаполнена",ЗначениеЗаполнено(Заявка));

	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если Не ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.УчетнаяЗапись) Тогда
			Продолжить;
		КонецЕсли;
		ОписаниеОшибки = "";
		Статус =  ОтправитьПисьмоОповещениеПоСобытию(ВыборкаДетальныеЗаписи.УчетнаяЗапись,ВыборкаДетальныеЗаписи.Событие,ВыборкаДетальныеЗаписи.Заявка,ВыборкаДетальныеЗаписи.ИдСобытия,ОписаниеОшибки);
		 Если Статус = Истина Тогда
			 МенеджерЗаписи = РегистрыСведений.ОповещенияПоЗаявкам.СоздатьМенеджерЗаписи();
			 ЗаполнитьЗначенияСвойств(МенеджерЗаписи,ВыборкаДетальныеЗаписи,"УчетнаяЗапись,Заявка,Событие,ИдСобытия");
			 МенеджерЗаписи.Прочитать();
			 Если МенеджерЗаписи.Выбран() Тогда
				 МенеджерЗаписи.ПисьмоОтправлено = Истина;
				 МенеджерЗаписи.ДатаОтправки = ТекущаяДата();
				 МенеджерЗаписи.Записать();
			 КонецЕсли;				 
		 Иначе
			СообщениеОбОшибке = "Во время отправки письма по событию заявки произошла ошибка - " + ОписаниеОшибки;
					Почта.ЗаписатьОшибкуВЖурналРегистрации(СообщениеОбОшибке); 
		 КонецЕсли;	 
	 КонецЦикла;
КонецПроцедуры

Функция ОтправитьПисьмоОповещениеПоСобытию(УчетнаяЗапись,Событие,Заявка,ИдСобытия,ОписаниеОшибки)
	
	//Определяем текст для подстановки
	СтруктураПоиска = Новый Структура();
	СтруктураПоиска.Вставить("Событие",Событие);

	ФайлКПисьму = Справочники.Файлы.ПустаяСсылка();
	МассивСтрокШаблона = УчетнаяЗапись.ОбработкаСобытийЗаявок.НайтиСтроки(СтруктураПоиска);
	Если МассивСтрокШаблона.Количество() = 0 Тогда
		Шаблон = "";
		ШаблонТемы = "";
	Иначе
		Шаблон = МассивСтрокШаблона.Получить(0).Сообщение;
		ШаблонТемы = МассивСтрокШаблона.Получить(0).Тема;
		ФайлКПисьму = МассивСтрокШаблона.Получить(0).Файл;
	КонецЕсли;			
	ШаблонПисьма = УстановитьПараметрыВТексте(Шаблон,Заявка);

	ДокументHTML = РаботаСHTML.ПолучитьДокументHTMLИзОбычногоТекста(ШаблонПисьма);
	Если ДокументHTML.Тело = Неопределено Тогда
		ШаблонHTML = ШаблонПисьма;
	Иначе
		ШаблонHTML = РаботаСHTML.ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML);
	КонецЕсли;
			
	ТаблицаКартинок = ПолучитьКартинкиИзЗаявки(Заявка,Новый УникальныйИдентификатор);	

	//Получим данные по дополнению для письма
	СтруктураПоиска = Новый Структура();
	СтруктураПоиска.Вставить("ИдДополнения",ИдСобытия);
	ОписаниеДополненияHTML = "";
	МассивФайлов = Новый Массив();
	Если Событие = Перечисления.ВидыСобытийПоЗаявке.Дополнение Тогда
		МассивСтрок = Заявка.ТекстыДополнений.НайтиСтроки(СтруктураПоиска);
		Если МассивСтрок.Количество()>0 Тогда
			ТекСтрокаСобытия = МассивСтрок.Получить(0);
			ОписаниеДополненияHTML = ТекСтрокаСобытия.ОписаниеДополненияHTML;
		КонецЕсли;	
		
		Для Каждого Стр Из ТаблицаКартинок Цикл
			Если СтрНайти(ОписаниеДополненияHTML,Стр.Ключ)> 0 Тогда
				Картинка = ПолучитьИзВременногоХранилища(Стр.Адрес);
				Если ТипЗнч(Картинка) = Тип("Картинка") Тогда
					Картинка = Картинка.ПолучитьДвоичныеДанные()
				ИначеЕсли ТипЗнч(Картинка) <> Тип("ДвоичныеДанные") Тогда 
					СообщениеОбОшибке = "Во время отправки письма произошла ошибка - ""Не предусмотреный тип картинки в тексте письма!""";
					Почта.ЗаписатьОшибкуВЖурналРегистрации(СообщениеОбОшибке);
					Продолжить;
				КонецЕсли;
				ИмяВремФайла = ПолучитьИмяВременногоФайла("jpg");
				Картинка.Записать(ИмяВремФайла);
				//ОписаниеДополненияHTML = СтрЗаменить(ОписаниеДополненияHTML,"src='"+Стр.Ключ,"src='data:image;base64," + Base64Строка(Картинка));
				//ОписаниеДополненияHTML = СтрЗаменить(ОписаниеДополненияHTML,"src="""+Стр.Ключ,"src=""data:image;base64," + Base64Строка(Картинка));
				
				ОписаниеДополненияHTML = СтрЗаменить(ОписаниеДополненияHTML,"src='"+Стр.Ключ,"src='file://" + ИмяВремФайла);
				ОписаниеДополненияHTML = СтрЗаменить(ОписаниеДополненияHTML,"src="""+Стр.Ключ,"src=""file://" + ИмяВремФайла);
				МассивФайлов.Добавить(ИмяВремФайла);
			КонецЕсли;					
		КонецЦикла;
	КонецЕсли;	
	
	ШаблонHTML = СтрЗаменить(ШаблонHTML,"##ОписаниеДополненияКЗаявке##","</p>"+ОписаниеДополненияHTML+"<p>");
	          
	Кодировка = "UTF-8";
	ЗаявкаHTML = РаботаСЗаявками.ПолучитьТекстHTMLЗаявки(Заявка,Кодировка,Новый УникальныйИдентификатор,Истина);
	ШаблонHTML = СтрЗаменить(ШаблонHTML,"##ИсторияПоЗаявке##","</p>"+ЗаявкаHTML+"<p>");
	
	УстановитьПредставлениеСсылкиНаЗаявку(ШаблонHTML,Заявка);

	Если ТипЗнч(Заявка.ДокументОснование) = Тип("ДокументСсылка.ВходящееПисьмо") Тогда
		//Меняем в шаблоне реквизиты на реквизиты заявки
		ТекстПисьма = СтрЗаменить(ШаблонHTML,"##ТекстИсходногоПисьма##",ВстроеннаяПочтаСервер.СформироватьПростойТекстДляПисьма(Заявка.ДокументОснование));	
		
		//Меняем в шаблоне темы текст
		ШаблонТемы = СтрЗаменить(ШаблонТемы,"##ТемаИсходногоПисьма##",Заявка.ДокументОснование.Тема);
		ТекстТемы = УстановитьПараметрыВТексте(ШаблонТемы,Заявка);	
	Иначе
		//Меняем в шаблоне реквизиты на реквизиты заявки
		ТекстПисьма = СтрЗаменить(ШаблонHTML,"##ТекстИсходногоПисьма##",Заявка.ОписаниеЗаявкиHTML);	
		
		//Меняем в шаблоне темы текст
		ШаблонТемы = СтрЗаменить(ШаблонТемы,"##ТемаИсходногоПисьма##",Заявка.Тема);
		ТекстТемы = УстановитьПараметрыВТексте(ШаблонТемы,Заявка);	
	КонецЕсли;
		
	ПолучателиПисьма = Новый СписокЗначений();
	ПолучателиКопий = Новый СписокЗначений();
	Если Событие = Перечисления.ВидыСобытийПоЗаявке.Получение Тогда
		//Отправляем текущему исполнителю
		Получатель = Заявка.ТекущийИсполнитель;
		Если ЗначениеЗаполнено(Получатель) Тогда
			АдресПолучателя = ПолучитьАдресПользователя(Получатель);
			Если ЗначениеЗаполнено(АдресПолучателя) Тогда
				ПолучателиПисьма.Добавить(АдресПолучателя,Получатель.Наименование);
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если Событие = Перечисления.ВидыСобытийПоЗаявке.Зарегистрирована Тогда
			Если ЗначениеЗаполнено(Заявка.ДокументОснование) И ТипЗнч(Заявка.ДокументОснование) = Тип("ДокументСсылка.ВходящееПисьмо") Тогда
				//В случае если заявка зарегистрирована по письму пользователя мы отсылаем ему ответ с номером заявки
				
				//Отправляем постановщику
				Получатель = Заявка.Постановщик;
				Если ЗначениеЗаполнено(Получатель) Тогда
					АдресПолучателя = ПолучитьАдресПользователя(Получатель);
					Если ЗначениеЗаполнено(АдресПолучателя) Тогда
						ПолучателиПисьма.Добавить(АдресПолучателя,Получатель.Наименование);
					КонецЕсли;
				КонецЕсли;
				
				// отправим копию распределителю
				Распределитель = УчетнаяЗапись.РаспределительЗаявок;
				Если ЗначениеЗаполнено(Распределитель) Тогда
					АдресРаспределителя = ПолучитьАдресПользователя(Распределитель);
					Если ЗначениеЗаполнено(АдресРаспределителя) Тогда
						ПолучателиКопий.Добавить(АдресРаспределителя,Распределитель.Наименование);
					КонецЕсли;
				КонецЕсли;	
			Иначе
				//В случае если заявка зарегистрирована вручную то
				// отправим только распределителю
				Распределитель = УчетнаяЗапись.РаспределительЗаявок;
				Если ЗначениеЗаполнено(Распределитель) Тогда
					АдресРаспределителя = ПолучитьАдресПользователя(Распределитель);
					Если ЗначениеЗаполнено(АдресРаспределителя) Тогда
						ПолучателиПисьма.Добавить(АдресРаспределителя,Распределитель.Наименование);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		Иначе //во всех остальных случаях	
			//Отправляем постановщику
			Получатель = Заявка.Постановщик;
			Если ЗначениеЗаполнено(Получатель) И Заявка.Постановщик <> Заявка.ТекущийИсполнитель Тогда
				АдресПолучателя = ПолучитьАдресПользователя(Получатель);
				Если ЗначениеЗаполнено(АдресПолучателя) Тогда
					ПолучателиПисьма.Добавить(АдресПолучателя,Получатель.Наименование);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		//Добавим данные подписчиков
		ТаблицаПодписчиков = ПолучитьТаблицуПодписчиков(Заявка);
		Для Каждого Стр Из ТаблицаПодписчиков Цикл
			Получатель = Стр.Пользователь;
			Если ЗначениеЗаполнено(Получатель) Тогда
				АдресПодписчика = ПолучитьАдресПользователя(Получатель);
				Если ЗначениеЗаполнено(АдресПодписчика) Тогда		
					ТекЭлем = ПолучателиПисьма.НайтиПоЗначению(АдресПодписчика);
					Если ТекЭлем <> Неопределено Тогда
						Продолжить;
					КонецЕсли;	
					ПолучателиПисьма.Добавить(АдресПодписчика,Получатель.Наименование);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	СписокВложений = Новый СписокЗначений;			
	
	//Прикрепим текст заявки
	//Кодировка = КодировкаТекста.UTF8;
	//ЗаявкаHTML = РаботаСЗаявками.ПолучитьТекстHTMLЗаявки(Заявка,Кодировка,Новый УникальныйИдентификатор);
	//ВложениеРазмер = СтрДлина(ЗаявкаHTML);	

	//ИмяВременногоФайла = ПолучитьИмяВременногоФайла("html");
	//ЗаписьТекста = Новый ЗаписьТекста(ИмяВременногоФайла, ?(ТипЗнч(Заявка.ДокументОснование) = Тип("ДокументСсылка.ВходящееПисьмо"),Заявка.ДокументОснование.Кодировка,КодировкаТекста.ANSI));
	//ЗаписьТекста.Записать(ЗаявкаHTML);
	//ЗаписьТекста.Закрыть();
	//Данные = Новый ДвоичныеДанные(ИмяВременногоФайла);
	//СписокВложений.Добавить(Данные,"Ticket#"+Заявка.Номер+".html");	
	
	КопироватьФайлыЗаявкиВПисьмо(Заявка,СписокВложений);
	
	Если ЗначениеЗаполнено(ФайлКПисьму) Тогда
		ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИДвоичныеДанные(ФайлКПисьму);
		ИмяФайла = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьИмяСРасширением(ДанныеФайла.ДанныеФайла.ПолноеНаименованиеВерсии, ДанныеФайла.ДанныеФайла.Расширение);
		СписокВложений.Добавить(ДанныеФайла.ДвоичныеДанные,ИмяФайла);
	КонецЕсли;		
	ОписаниеОшибки = "";
	Возврат ОтправитьСервисноеСообщение(УчетнаяЗапись,ПолучателиПисьма,ПолучателиКопий,ТекстТемы,ТекстПисьма,СписокВложений,ОписаниеОшибки,1);
КонецФункции

Функция ПолучитьКартинкиИзЗаявки(ЗаявкаСсылка,УникальныйИдентификатор)  Экспорт
	ТаблицаКартнок = Новый ТаблицаЗначений;
	ТаблицаКартнок.Колонки.Добавить("Ключ");
	ТаблицаКартнок.Колонки.Добавить("Адрес");
	
	// прочитаем картинки заявки 
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбъектыHTMLСтраниц.Идентификатор,
	|	ОбъектыHTMLСтраниц.Вложение
	|ИЗ
	|	РегистрСведений.ОбъектыHTMLСтраниц КАК ОбъектыHTMLСтраниц
	|ГДЕ
	|	ОбъектыHTMLСтраниц.Владелец = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ЗаявкаСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НоваяСтрока = ТаблицаКартнок.Добавить();
		НоваяСтрока.Ключ = ВыборкаДетальныеЗаписи.Идентификатор;
		НоваяСтрока.Адрес = ПоместитьВоВременноеХранилище(ВыборкаДетальныеЗаписи.Вложение.Получить(),УникальныйИдентификатор);
	КонецЦикла;
	
	Возврат ТаблицаКартнок;
КонецФункции // ПолучитьКартинкиИзЗаявки()

Функция ПолучитьАдресПользователя(Пользователь) Экспорт
	
	ТаблицаКонтактов = УправлениеКонтактнойИнформацией.ЗначенияКонтактнойИнформацииОбъекта(
		Пользователь,
		Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
		
	Если ТаблицаКонтактов.Количество() > 0 Тогда
		Возврат ТаблицаКонтактов[0].Значение;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Процедура КопироватьФайлыЗаявкиВПисьмо(Заявка,СписокВложений) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Файлы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Файлы КАК Файлы		
		|ГДЕ
		|	Файлы.ВладелецФайла = &Заявка
		|");
		
	Запрос.УстановитьПараметр("Заявка", Заявка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИДвоичныеДанные(Выборка.Ссылка);
		ИмяФайла = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьИмяСРасширением(ДанныеФайла.ДанныеФайла.ПолноеНаименованиеВерсии, ДанныеФайла.ДанныеФайла.Расширение);
		СписокВложений.Добавить(ДанныеФайла.ДвоичныеДанные,ИмяФайла);
	КонецЦикла;
КонецПроцедуры

Функция ПолучитьТаблицуПодписчиков(Заявка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПодписчикиЗаявок.Пользователь
		|ИЗ
		|	РегистрСведений.ПодписчикиЗаявок КАК ПодписчикиЗаявок
		|ГДЕ
		|	ПодписчикиЗаявок.Заявка = &Заявка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПодписчикиЗаявок.Пользователь";
	
	Запрос.УстановитьПараметр("Заявка", Заявка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблВозврата = РезультатЗапроса.Выгрузить();
	
	Возврат ТаблВозврата;	
КонецФункции

Функция УстановитьПараметрыВТексте(Шаблон,Заявка)
	СоответствиеПараметров = Новый Соответствие();
	
	НачПоз = 1;
	Пока СтрНайти(Шаблон,"##<",,?(НачПоз>=СтрДлина(Шаблон),СтрДлина(Шаблон),НачПоз))<> 0 Цикл
		НачалоЭлемента = СтрНайти(Шаблон,"##<",,НачПоз)+3;
		КонецЭлемента =  СтрНайти(Шаблон,">##",,НачалоЭлемента);
		
		Если КонецЭлемента = 0 Тогда
			//Похоже не закрыли тег
			Прервать;
		КонецЕсли;	
		
		ТекстПараметра = СокрЛП(Сред(Шаблон,НачалоЭлемента,КонецЭлемента-НачалоЭлемента));
		ТекстПараметра = СтрЗаменить(ТекстПараметра,"<","");
		ТекстПараметра = СтрЗаменить(ТекстПараметра,">","");
		ТекстПараметра = СтрЗаменить(ТекстПараметра," ","");
		
		СоответствиеПараметров.Вставить(СокрЛП(ТекстПараметра),"");
		
		НачПоз = КонецЭлемента+3;
	КонецЦикла;	
	
	Для Каждого Стр Из СоответствиеПараметров Цикл
		ТекПараметр = Стр.Ключ;
		Если СтрНайти(Шаблон,".")<> 0 Тогда //У нас сложный параметр
			мнСтрока = СтрЗаменить(ТекПараметр,".",Символы.ПС);
			СтрокаВыполнения = "";
			Значение ="";

			Для Счетчик = 1 По СтрЧислоСтрок(мнСтрока) Цикл
    			ТекСтрокаПараметра = СтрПолучитьСтроку(мнСтрока, Счетчик);
				СтрокаВыполнения = ?(Счетчик = 1,"Заявка","")+СтрокаВыполнения + "["""+СокрЛП(ТекСтрокаПараметра)+"""]";
			КонецЦикла;
			Попытка
				Если ЗначениеЗаполнено(СтрокаВыполнения) Тогда 
					СтрокаВыполнения = "Значение = Строка(" + СтрокаВыполнения+")";
					Выполнить(СтрокаВыполнения);
				Иначе
					Значение ="";
				КонецЕсли;
			Исключение КонецПопытки;
		Иначе
			Попытка
				Значение = Строка(Заявка[ТекПараметр]);	
			Исключение КонецПопытки;	
		КонецЕсли;	
		Шаблон = СтрЗаменить(Шаблон,"##<"+Стр.Ключ+">##",Значение);	
	КонецЦикла;
	
	Возврат Шаблон;
КонецФункции

Процедура УстановитьПредставлениеСсылкиНаЗаявку(Шаблон,Заявка)
	ПредставлениеСсылки = "Ссылка на заявку";
	СсылкаНаЗаявку = СокрЛП(Константы.НавигационнаяСсылкаНаБазу.Получить())+"#"+ПолучитьНавигационнуюСсылку(Заявка);
	
	//Сначала обработаем те ссылки которые не имеют представления
	Шаблон = СтрЗаменить(Шаблон,"##СсылкаНаЗаявку##","<h2 style=""margin:0cm;margin-bottom:.0001pt;line-height:12pt""><span style=""font-size:9pt;font-family:""Trebuchet MS"",sans-serif;mso-fareast-font-family:""Times New Roman"";color:#222222""><a href='"+СсылкаНаЗаявку+"'>"+ПредставлениеСсылки+"</a></span></h2>");

	//Затем обработаем ссылки которые имеют представление
	НачПоз = 1;
	Пока СтрНайти(Шаблон,"##СсылкаНаЗаявку{",,?(НачПоз>=СтрДлина(Шаблон),СтрДлина(Шаблон),НачПоз))<> 0 Цикл
		НачалоЭлемента = СтрНайти(Шаблон,"##СсылкаНаЗаявку{",,НачПоз)+17;
		КонецЭлемента =  СтрНайти(Шаблон,"}##",,НачалоЭлемента);
		
		Если КонецЭлемента = 0 Тогда
			//Похоже не закрыли тег
			Прервать;
		КонецЕсли;	
		
		ТекстПараметра = СокрЛП(Сред(Шаблон,НачалоЭлемента,КонецЭлемента-НачалоЭлемента));
		ТекстПараметра = СтрЗаменить(ТекстПараметра,"}","");
		ТекстПараметра = СтрЗаменить(ТекстПараметра,"{","");

		Шаблон = Лев(Шаблон,НачалоЭлемента-18) +"<h2 style=""margin:0cm;margin-bottom:.0001pt;line-height:12pt""><span style=""font-size:9pt;font-family:""Trebuchet MS"",sans-serif;mso-fareast-font-family:""Times New Roman"";color:#222222""><a href='"+СсылкаНаЗаявку+"'>"+ТекстПараметра+"</a></span></h2>"+ Сред(Шаблон,КонецЭлемента+3); 	
		НачПоз = КонецЭлемента+17;
	КонецЦикла;
	
КонецПроцедуры

//процедура создана на базе типовой процедуры ЗаписатьИзмененияНаСервере модуля общей формы ПраваДоступаУпрощенно
Процедура ОбновитьПраваПользователя(Пользователь, ПрофилиПользователя) 
	
	// Получение списка изменений.
	Запрос = Новый Запрос;
		
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Профили", ПрофилиПользователя);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Профили.Профиль КАК Ссылка,
	|	Профили.Пометка
	|ПОМЕСТИТЬ Профили
	|ИЗ
	|	&Профили КАК Профили
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Профили.Ссылка,
	|	ЕСТЬNULL(ГруппыДоступа.Ссылка, НЕОПРЕДЕЛЕНО) КАК ПерсональнаяГруппаДоступа,
	|	ВЫБОР
	|		КОГДА ГруппыДоступаПользователи.Ссылка ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Пометка
	|ПОМЕСТИТЬ ТекущиеПрофили
	|ИЗ
	|	Справочник.ПрофилиГруппДоступа КАК Профили
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа КАК ГруппыДоступа
	|		ПО Профили.Ссылка = ГруппыДоступа.Профиль
	|			И (ГруппыДоступа.Пользователь = &Пользователь
	|				ИЛИ Профили.Ссылка В (ЗНАЧЕНИЕ(Справочник.ПрофилиГруппДоступа.Администратор)))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|		ПО (ГруппыДоступа.Ссылка = ГруппыДоступаПользователи.Ссылка)
	|			И (ГруппыДоступаПользователи.Пользователь = &Пользователь)
	|ГДЕ
	|	НЕ Профили.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Профили.Ссылка КАК Профиль,
	|	ГруппыДоступаЗначенияДоступа.ВидДоступа,
	|	ГруппыДоступаЗначенияДоступа.ЗначениеДоступа
	|ПОМЕСТИТЬ ТекущиеЗначенияДоступа
	|ИЗ
	|	ТекущиеПрофили КАК Профили
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.ЗначенияДоступа КАК ГруппыДоступаЗначенияДоступа
	|		ПО Профили.ПерсональнаяГруппаДоступа = ГруппыДоступаЗначенияДоступа.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПрофилиИзмененныхГрупп.Профиль
	|ПОМЕСТИТЬ ПрофилиИзмененныхГрупп
	|ИЗ
	|	(ВЫБРАТЬ
	|		Профили.Ссылка КАК Профиль
	|	ИЗ
	|		Профили КАК Профили
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТекущиеПрофили КАК ТекущиеПрофили
	|			ПО Профили.Ссылка = ТекущиеПрофили.Ссылка
	|	ГДЕ
	|		Профили.Пометка <> ТекущиеПрофили.Пометка) КАК ПрофилиИзмененныхГрупп
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Профили.Ссылка КАК Профиль,
	|	СправочникПрофили.Наименование КАК ПрофильНаименование,
	|	Профили.Пометка,
	|	ТекущиеПрофили.ПерсональнаяГруппаДоступа
	|ИЗ
	|	ПрофилиИзмененныхГрупп КАК ПрофилиИзмененныхГрупп
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Профили КАК Профили
	|		ПО ПрофилиИзмененныхГрупп.Профиль = Профили.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТекущиеПрофили КАК ТекущиеПрофили
	|		ПО ПрофилиИзмененныхГрупп.Профиль = ТекущиеПрофили.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПрофилиГруппДоступа КАК СправочникПрофили
	|		ПО (СправочникПрофили.Ссылка = ПрофилиИзмененныхГрупп.Профиль)";
	
	//НачатьТранзакцию();
	Попытка
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если ЗначениеЗаполнено(Выборка.ПерсональнаяГруппаДоступа) Тогда
				ЗаблокироватьДанныеДляРедактирования(Выборка.ПерсональнаяГруппаДоступа);
				ГруппаДоступаОбъект = Выборка.ПерсональнаяГруппаДоступа.ПолучитьОбъект();
			Иначе
				// Создание персональной группы доступа.
				ГруппаДоступаОбъект = Справочники.ГруппыДоступа.СоздатьЭлемент();
				//ГруппаДоступаОбъект.Родитель     = Справочники.ГруппыДоступа.РодительПерсональныхГруппДоступа();
				ГруппаДоступаОбъект.Наименование = Выборка.ПрофильНаименование;
				ГруппаДоступаОбъект.Пользователь = Пользователь;
				ГруппаДоступаОбъект.Профиль      = Выборка.Профиль;
			КонецЕсли;
			
			Если Выборка.Профиль = Справочники.ПрофилиГруппДоступа.Администратор Тогда
				
				Если Выборка.Пометка Тогда
					Если ГруппаДоступаОбъект.Пользователи.Найти(
							Пользователь, "Пользователь") = Неопределено Тогда
						
						ГруппаДоступаОбъект.Пользователи.Добавить().Пользователь = Пользователь;
					КонецЕсли;
				Иначе
					ОписаниеПользователя =  ГруппаДоступаОбъект.Пользователи.Найти(
						Пользователь, "Пользователь");
					
					Если ОписаниеПользователя <> Неопределено Тогда
						ГруппаДоступаОбъект.Пользователи.Удалить(ОписаниеПользователя);
						
						Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
							// Проверка пустого списка пользователей ИБ в группе доступа Администраторы.
							НайденПользовательИБ = Ложь;
							Для каждого ОписаниеПользователя ИЗ ГруппаДоступаОбъект.Пользователи Цикл
								Если ЗначениеЗаполнено(ОписаниеПользователя.Пользователь)
								   И ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
								     	ОписаниеПользователя.Пользователь.ИдентификаторПользователяИБ)
								     	<> Неопределено Тогда
									
									НайденПользовательИБ = Истина;
									Прервать;
								КонецЕсли;
							КонецЦикла;
							Если НЕ НайденПользовательИБ Тогда
								ВызватьИсключение
									НСтр("ru = 'Профиль Администратор должен быть хотя бы у одного пользователя,
									           |которому разрешен доступ к информационной базе.'");
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			Иначе
				ГруппаДоступаОбъект.Пользователи.Очистить();
				Если Выборка.Пометка Тогда
					ГруппаДоступаОбъект.Пользователи.Добавить().Пользователь = Пользователь;
				КонецЕсли;
				
			КонецЕсли;
			ГруппаДоступаОбъект.Записать();
			
			Если ЗначениеЗаполнено(Выборка.ПерсональнаяГруппаДоступа) Тогда
				РазблокироватьДанныеДляРедактирования(Выборка.ПерсональнаяГруппаДоступа);
			КонецЕсли;
		КонецЦикла;
		//ЗафиксироватьТранзакцию();
		Модифицированность = Ложь;
	Исключение
		//ОтменитьТранзакцию();
		ЕстьОшибки = Истина;
		ВызватьИсключение ("Ошибка про создании/обновлении прав пользователя " + Пользователь + ": " + Символы.ПС + ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

Процедура ДобавитьОтветКЗаявке(Письмо,Заявка)
	Постановщик = РаботаСЗаявкамиИПочтой.НайтиСоздатьПользователяПоАдресуОтправителя(Письмо.ОтправительАдрес);
	
	ТекстПисьма = Письмо.ТекстПисьмаHTMLХранилище.Получить();
	
	Если ТекстПисьма = Неопределено Тогда
		ТекстПисьма = Письмо.ТекстПисьмаПростойТекстХранилище.Получить();
		Если ТекстПисьма <> Неопределено Тогда
			ТекстПисьма = "<p>"+ТекстПисьма+"</p>";
		Иначе
			ТекстПисьма = "";
		КонецЕсли;	
	КонецЕсли;
	
	ТаблицаВложения = ВстроеннаяПочтаСервер.ПолучитьФайлыПисьма(
	Письмо, // Письмо
	Истина, // ФормироватьРазмерПредставление
	Истина); // ВключатьПомеченныеНаУдаление

	//Обработаем текст письма если он пришел от outlok 2003 и выше
	ТекстПисьма = ВыделитьТекстПисьмаOutlook(ТекстПисьма);

	Заявкаобъект = Заявка.Получитьобъект();
	СтруктураТекстов = Заявкаобъект.ПолучитьСтруктуруТекстовСВложениями(ТекстПисьма,ТаблицаВложения);	
	
	НовСтр = Заявкаобъект.ТекстыДополнений.Добавить();	
	НовСтр.ТипДополнения =  Перечисления.ВидыСобытийПоЗаявке.Дополнение;
	НовСтр.ОписаниеДополнения  = СтруктураТекстов.ОписаниеЗаявки;
	НовСтр.ОписаниеДополненияHTML = СтруктураТекстов.ОписаниеЗаявкиHTML;
	НовСтр.ИдДополнения = Строка(Новый УникальныйИдентификатор());
	НовСтр.ДатаСоздания = Текущаядата();
	НовСтр.Пользователь = Постановщик;
	
	Если ЗаявкаОбъект.Статус = Справочники.СостоянияЗаявок.Выполнена Тогда
		ЗаявкаОбъект.Статус = Справочники.СостоянияЗаявок.Зарегистрирована;
		ЗаявкаОбъект.ДатаЗакрытия = Дата(1,1,1);
		ЗаявкаОбъект.ЗаявкаЗакрыта = Ложь;
	КонецЕсли;
	
	Заявкаобъект.КопироватьФайлыПисьмаВЗаявку(Письмо);
	Заявкаобъект.СохранитьОбъектыВложенийHTML(СтруктураТекстов.ОписаниеЗаявкиHTML,Заявкаобъект.ТаблицаВложенийОбъекта.Выгрузить()); 
	Заявкаобъект.ТаблицаВложенийОбъекта.Очистить();
	
	Заявкаобъект.Записать();
КонецПроцедуры

Функция ВыделитьТекстПисьмаOutlook (Знач ТекстПисьма)  Экспорт
	Если СтрНайти(ТекстПисьма,"content=""Microsoft") <> 0 Тогда
		НачалоПисьма = СтрНайти(ТекстПисьма,"div class=""WordSection");
		Если НачалоПисьма <> 0 Тогда
			КонецПисьма = СтрНайти(ТекстПисьма,"<div>",,НачалоПисьма);
			Если КонецПисьма <> 0 Тогда
				ТекстПисьма = Сред(ТекстПисьма,НачалоПисьма-1,КонецПисьма-НачалоПисьма+6);
			КонецЕсли;	
		КонецЕсли;		
	КонецЕсли;	
	Возврат ТекстПисьма;
КонецФункции

Функция ОпределитьЗаявкуОснованиеПоПисьму(Письмо)
	 Заявка = Документы.Заявка.ПустаяСсылка();
	 
	 ТемаПисьма = Письмо.Тема;
	 
	 НомРазделителя = СтрНайти(ТемаПисьма,"#"); 
	 Если НомРазделителя > 0 Тогда
		НомПробела  = СтрНайти(ТемаПисьма," ",,НомРазделителя);
		Если ЗначениеЗаполнено(НомПробела) Тогда
			НомерЗаявки = СокрЛП(Сред(ТемаПисьма,НомРазделителя+1,НомПробела-НомРазделителя));
		Иначе
			НомерЗаявки = СокрЛП(Сред(ТемаПисьма,НомРазделителя+1));
		КонецЕсли;
		
		Попытка 
			НомерЗаявкиЧислом = Число(НомерЗаявки);
		Исключение 
			Возврат Заявка;
		КонецПопытки;	
		
		Заявка = Документы.Заявка.НайтиПоНомеру(НомерЗаявкиЧислом,ТекущаяДата());
	 КонецЕсли;
	 
	 Возврат Заявка;
КонецФункции

// Отправляет с адреса сервера
//
// Параметры
//  УчетнаяЗапись 			- Ссілка на справолчник учетніх записей
//  АдресаПолучателей 			- Строка, СписокЗначений - эл.адреса получателей сообщения
//  АдресаПолучателейКопий 			- Строка, СписокЗначений - эл.адреса получателей копий сообщения
//  Тема 						- Строка 		 - Тема сообщения
//  ТекстСообщения 				- Строка 		 - Текст в теле сообщения
//  ФайлыВложения 				- СписокЗначений - СписокЗначений, где Представление - Наименование вложения,
//								как оно отображается в почтовом клиенте, а Значение - Двоичные данные вложения.
//	ОписаниеОшибки  - Строка, содержит возвращаемое описание ошибки
//  ТипСообщения - Число, 1-HTML, 0 - текст
//
Функция ОтправитьСервисноеСообщение(УчетнаяЗапись,АдресаПолучателей,АдресаПолучателейКопий=Неопределено, Тема = "<Без темы>", ТекстСообщения = "", ФайлыВложения = Неопределено, ОписаниеОшибки = "",ТипСообщения=0) Экспорт
			
	Если не ЗначениеЗаполнено(УчетнаяЗапись.АдресЭлектроннойПочты) Тогда
		ОписаниеОшибки = "Не заполнена учетная запись по умолчанию для электронной почты!";
		Возврат Ложь;
	КонецЕсли;
	
	Если (НЕ ЗначениеЗаполнено(АдресаПолучателей)) ИЛИ ПустаяСтрока(Строка( АдресаПолучателей) ) Тогда
		ОписаниеОшибки = "Список адресатов пуст!";
		Возврат Ложь;
	КонецЕсли;
	
	ИПП = Новый ИнтернетПочтовыйПрофиль; 
	ИПП.АдресСервераSMTP = УчетнаяЗапись.СерверИсходящейПочтыSMTP;
	ИПП.ИспользоватьSSLSMTP = УчетнаяЗапись.ИспользоватьSSLSMTP;
	
	ИПП.ПарольSMTP = УчетнаяЗапись.ПарольSMTP; 
	ИПП.ПользовательSMTP = УчетнаяЗапись.ПользовательSMTP;
	ИПП.ПортSMTP = УчетнаяЗапись.ПортSMTP;
	ИПП.Пользователь = УчетнаяЗапись.Пользователь; 
	ИПП.Пароль = УчетнаяЗапись.Пароль;
	
	Попытка
		ОбъектПочта = Новый ИнтернетПочта; 
		ОбъектПочта.Подключиться(ИПП); 
	Исключение
		СообщениеОтправлено = Ложь;
		ОписаниеОшибки = ОписаниеОшибки();
		Возврат СообщениеОтправлено;
	КонецПопытки;
	
	Сообщение = Новый ИнтернетПочтовоеСообщение;
	
	Если ТипЗнч(АдресаПолучателей) = Тип( "Строка") Тогда
		
		Сообщение.Получатели.Добавить(АдресаПолучателей);
		
	Иначе
		
		Для каждого АдресПолучателя Из АдресаПолучателей Цикл
			Адрес = Сообщение.Получатели.Добавить(АдресПолучателя.Значение);
			Адрес.ОтображаемоеИмя = АдресПолучателя.Представление;
		КонецЦикла;
	
	КонецЕсли;
	
	Если ТипЗнч(АдресаПолучателейКопий) = Неопределено Тогда
		
	ИначеЕсли ТипЗнч(АдресаПолучателейКопий)= Тип( "Строка") Тогда
		
		Сообщение.Копии.Добавить(АдресаПолучателейКопий);
		
	Иначе
		
		Для каждого АдресПолучателя Из АдресаПолучателейКопий Цикл
			Адрес = Сообщение.Копии.Добавить(АдресПолучателя.Значение);
			Адрес.ОтображаемоеИмя = АдресПолучателя.Представление;
		КонецЦикла;
	
	КонецЕсли;

	Сообщение.Отправитель.Адрес = УчетнаяЗапись.АдресЭлектроннойПочты;
	
	Сообщение.Тема = Тема; 
		
	Если ТипСообщения=1 Тогда
		Сообщение.Тексты.Добавить(ТекстСообщения,ТипТекстаПочтовогоСообщения.HTML);
		Сообщение.ОбработатьТексты();
	Иначе	  
		Сообщение.Тексты.Добавить(ТекстСообщения);
	КонецЕсли;

	
	Если ФайлыВложения <> Неопределено Тогда
		Для каждого ФайлВложения Из ФайлыВложения Цикл
			Сообщение.Вложения.Добавить(ФайлВложения.Значение, ФайлВложения.Представление);
		КонецЦикла;
	КонецЕсли;
	
	Попытка
		//Сообщение.УстановитьПолеЗаголовка("X-Database", СтрокаСоединенияИнформационнойБазы(),СпособКодированияНеASCIIСимволовИнтернетПочтовогоСообщения.БезКодирования); 
		ОбъектПочта.Послать(Сообщение); 	
		СообщениеОтправлено = Истина;
		ОбъектПочта.Отключиться();		

	Исключение
		СообщениеОтправлено = Ложь;
		ОписаниеОшибки = ОписаниеОшибки(); 
	КонецПопытки;
	
	ОбъектПочта = Неопределено;		
	
	Возврат СообщениеОтправлено;
	
КонецФункции
