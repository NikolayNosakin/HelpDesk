﻿Функция ЭтоСтрокаКартинки(знач СтрокаПроверки) Экспорт
	
	СтрокаПроверки = СокрЛП(СтрокаПроверки);
	Возврат НРег(Лев(СтрокаПроверки, 10)) = НРег("[picture='");
	
КонецФункции

Функция ПолучитьИмяКартинки(знач СтрокаКартинки) Экспорт
	
	ИмяКартинки = "";
	
	Если ЭтоСтрокаКартинки(СтрокаКартинки) Тогда
		
		СтрокаКартинки	= СокрЛП(СтрокаКартинки);
		ЧастьИмени		= Сред(СтрокаКартинки, 11);
		Окончание		= СтрНайти(ЧастьИмени, "'");
		
		Если Окончание > 0 Тогда
			ИмяКартинки = Сред(ЧастьИмени, 1, Окончание - 1);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИмяКартинки;
	
КонецФункции

Функция ЭтоСтрокаТаблицы(знач СтрокаПроверки) Экспорт 
	
	СтрокаПроверки = СокрЛП(СтрокаПроверки);
	Возврат НРег(Лев(СтрокаПроверки, 8)) = НРег("[table='");
	
КонецФункции

Функция ПолучитьИмяТаблицы(знач СтрокаТаблицы) Экспорт
	
	ИмяТаблицы = "";
	
	Если ЭтоСтрокаТаблицы(СтрокаТаблицы) Тогда
		
		СтрокаТаблицы	= СокрЛП(СтрокаТаблицы);
		ЧастьИмени		= Сред(СтрокаТаблицы, 9);
		Окончание		= СтрНайти(ЧастьИмени, "'");
		
		Если Окончание > 0 Тогда
			ИмяТаблицы = Сред(ЧастьИмени, 1, Окончание - 1);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИмяТаблицы;
	
КонецФункции

Функция ПроверитьПравильностьЗаполненияИмени(знач Имя) Экспорт
	
	ПерваяЦифра = СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Лев(Имя, 1), Истина, Ложь);
	
	ПроверкаПройдена = Истина;
	Если НЕ ПерваяЦифра Тогда
		ДопустимыеСимволы	= БазаЗнанийКлиентСерверПовтИсп.ПолучитьДопустимыеСимволыИмени();
		ДлинаСтроки			= СтрДлина(Имя);
		Для Индекс = 1 По ДлинаСтроки Цикл
			СимволПроверки = Сред(Имя, Индекс, 1);
			Если Найти(ДопустимыеСимволы, НРег(СимволПроверки)) = 0 Тогда
				ПроверкаПройдена = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Иначе 
		ПроверкаПройдена = Ложь;
	КонецЕсли;
	
	Возврат ПроверкаПройдена;			
	
КонецФункции

Функция СохранитьКартинкуСайта(КаталогСохранения,КартинкаНаСайте,КартинкаУНас) Экспорт
	ИмяФайлаКартинки = КаталогСохранения + "\" + КартинкаУНас;
	//ГетЗапрос = Новый COMОбъект("WinHttp.WinHttpRequest.5.1");
	//ГетЗапрос.SetTimeouts(10000, 10000, 10000, 10000);
	//БазовыйУРЛ = КартинкаНаСайте;
	//Хидер1 = "Content-Type";
	//Хидер2 = "image/jpg"; // Тип рисунка.
	//
	//БазовыйУРЛ = БазаЗнанийСервер.КодироватьСтрокуАдресаСайта(БазовыйУРЛ);
	//
	//ГетЗапрос.Open("GET", БазовыйУРЛ, False); // Синхронный режим.
	//ГетЗапрос.setRequestHeader(Хидер1, Хидер2);
	//ГетЗапрос.Send();
	//СтатусОтправки = ГетЗапрос.status;
	//Если СтатусОтправки <> 200 Тогда
	//	Сообщить("Ошибка отправки запроса на: "
	//	+ КартинкаНаСайте);
	//	Возврат "";
	//КонецЕсли;        
	//
	//Стрим = Новый COMОбъект("ADODB.Stream");
	//Стрим.Mode = 3;
	//Стрим.Type = 1;
	//Стрим.Open();
	//Стрим.Write(ГетЗапрос.responseBody);
	//
	//Стрим.SaveToFile(ИмяФайлаКартинки, 2);
	//Стрим.Close();
	//Возврат ИмяФайлаКартинки;
	
	Картинка = ПолучитьДвоичныеДанныеКартинки(КартинкаНаСайте);		
	Картинка.Записать(ИмяФайлаКартинки);
	
	Возврат ИмяФайлаКартинки;	
КонецФункции  

Функция ПолучитьДвоичныеДанныеКартинки(Путь) Экспорт
	
	// Получаем структуру адреса сайта
	СтруктураАдреса = РазобратьАдресСайта(Путь);
	
	ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
			
	// Устанавливаем соединение с сайтом
	Соединение = Новый HTTPСоединение(СтруктураАдреса.HTTPСервер,,,,,,?(СтруктураАдреса.HTTPЗащищенноеСоединение=Истина,ЗащищенноеСоединение,Неопределено));
	
	// Устанавливаем http запрос что бы получить картинку по адресу
	Запрос = Новый HTTPЗапрос(СтруктураАдреса.HTTPАдресСкрипта);
	Ответ = Соединение.Получить(Запрос);
	
	// Возвращаем двоичные данные
	Возврат Ответ.ПолучитьТелоКакДвоичныеДанные();
	
КонецФункции

Функция РазобратьАдресСайта(Знач АдресСайта) Экспорт
	
	// Разберем адрес сайта
	АдресСайта = СокрЛП(АдресСайта); 
	
	HTTPСервер		 			= ""; 
	HTTPПорт					= 0;
	HTTPАдресСкрипта 			= "";
	HTTPЗащищенноеСоединение 	= Ложь;
	
	Если ЗначениеЗаполнено(АдресСайта) Тогда
		
		АдресСайта = СтрЗаменить(АдресСайта, "\", "/");
		АдресСайта = СтрЗаменить(АдресСайта, " ", "");
		
		Если ВРег(Лев(АдресСайта, 7)) = "HTTP://" Тогда
			АдресСайта = Сред(АдресСайта, 8);
		ИначеЕсли ВРег(Лев(АдресСайта, 8)) = "HTTPS://" Тогда
			АдресСайта = Сред(АдресСайта, 9);
			HTTPЗащищенноеСоединение = Истина;
		КонецЕсли;
		
		ПозицияСлэша = СтрНайти(АдресСайта, "/");
		
		Если ПозицияСлэша > 0 Тогда
			HTTPСервер 		 = Лев(АдресСайта, ПозицияСлэша - 1);
			HTTPАдресСкрипта = Прав(АдресСайта, СтрДлина(АдресСайта) - ПозицияСлэша);
		Иначе	
			HTTPСервер 		 = АдресСайта;
			HTTPАдресСкрипта = "";
		КонецЕсли;	
		ПозицияДвоеточия = СтрНайти(HTTPСервер, ":");
		Если ПозицияДвоеточия > 0 Тогда
			HTTPСерверСПортом = HTTPСервер;
			HTTPСервер		  = Лев(HTTPСерверСПортом, ПозицияДвоеточия - 1);
			HTTPПортСтрока 	  = Прав(HTTPСерверСПортом, СтрДлина(HTTPСерверСПортом) - ПозицияДвоеточия);
		Иначе
			HTTPПортСтрока = "0";
		КонецЕсли;
		
		HTTPПорт = ПривестиСтрокуКЧислу(HTTPПортСтрока);
		
	КонецЕсли;
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("HTTPСервер"	  			, HTTPСервер); 
	СтруктураРезультата.Вставить("HTTPПорт"		   			, HTTPПорт);
	СтруктураРезультата.Вставить("HTTPАдресСкрипта"			, HTTPАдресСкрипта);
	СтруктураРезультата.Вставить("HTTPЗащищенноеСоединение"	, HTTPЗащищенноеСоединение);
	
	Возврат СтруктураРезультата;
	
КонецФункции

Функция ПривестиСтрокуКЧислу(ЧислоСтрокой, ВозвращатьНеопределено = Ложь) Экспорт
	
	ОписаниеТипаЧисла = Новый ОписаниеТипов("Число");
	ЗначениеЧисла = ОписаниеТипаЧисла.ПривестиЗначение(ЧислоСтрокой);
	
	Если ВозвращатьНеопределено И (ЗначениеЧисла = 0) Тогда
		
		Стр = Строка(ЧислоСтрокой);
		Если Стр = "" Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Стр = СтрЗаменить(СокрЛП(Стр), "0", "");
		Если (Стр <> "") И (Стр <> ".") И (Стр <> ",") Тогда
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗначениеЧисла;	
	
КонецФункции

Функция ПеревестиИз10(Знач Значение = 0) Экспорт
	
	Значение = Число(Значение);
	Если Значение <= 0 Тогда
		Возврат "00";
	КонецЕсли;
	
	Значение = Цел(Значение);
	Результат = "";
	
	Пока Значение > 0 Цикл
		Результат = Сред("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",Значение%16+1,1) + Результат;
		Значение = Цел(Значение/16);
	КонецЦикла;
	
	Если СтрДлина(Результат) = 1 Тогда
		Результат = "0" + Результат;
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции

Процедура ВставитьКартинкиВТекстHTML(ТекстСтатьиHTML,ТабликаКартинок,УникальныйИдентификатор) Экспорт
	
	//вставляем идентификаторы картинок
	Для Каждого Стр Из ТабликаКартинок Цикл
		Если ЗначениеЗаполнено(Стр.Адрес) Тогда
			Продолжить;
		КонецЕсли;	
		Если Найти(ТекстСтатьиHTML,Стр.Ключ) = 0 Тогда
			Продолжить;
		КонецЕсли;	
		ТекКартинка = Стр.Значение;
		АдресКартинки = ПоместитьВоВременноеХранилище(ТекКартинка,УникальныйИдентификатор);
		Стр.Адрес = АдресКартинки;
		
		//Если прописано через src
		ТекстСтатьиHTML = СтрЗаменить(ТекстСтатьиHTML,"src="""+Стр.Ключ,"src="""+АдресКартинки); 
	КонецЦикла;
	РаботаСHTML.ПередатьОбъектыСтраницыНаКлиента(ТекстСтатьиHTML,ТабликаКартинок);
КонецПроцедуры
