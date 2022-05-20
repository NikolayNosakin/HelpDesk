﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Файловые функции".
//
////////////////////////////////////////////////////////////////////////////////

// Персональные настройки состоят из настроек подсистемы ФайловыеФункции
// (см. ФайловыеФункцииСлужебный.ПолучитьПерсональныеНастройкиФайловыхФункций),
// а также настроек подсистем РаботаСФайлами и ПрисоедиенныеФайлы,
// которые добавляются через процедуру ПолучитьПерсональныеНастройкиФайловыхФункций
// модуля СтандартныеПодсистемыПереопределяемый.
//
Функция ПерсональныеНастройкиРаботыСФайлами() Экспорт

#Если Сервер ИЛИ ВнешнееСоединение Тогда
	Возврат ФайловыеФункцииСлужебныйПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами();
#Иначе
	Возврат ФайловыеФункцииСлужебныйКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами();
#КонецЕсли

КонецФункции

// Возвращает флажок наличия хотя бы одного файла в томах.
Функция ЕстьФайлыВТомах() Экспорт
	
	Возврат ФайловыеФункцииСлужебныйВызовСервера.ЕстьФайлыВТомах();
	
КонецФункции

// функция возвращает часть строки после последнего встреченного символа в строке
Функция ПолучитьСтрокуОтделеннойСимволом(Знач ИсходнаяСтрока, Знач СимволПоиска)
	
	ПозицияСимвола = СтрДлина(ИсходнаяСтрока);
	Пока ПозицияСимвола >= 1 Цикл
		
		Если Сред(ИсходнаяСтрока, ПозицияСимвола, 1) = СимволПоиска Тогда
						
			Возврат Сред(ИсходнаяСтрока, ПозицияСимвола + 1); 
			
		КонецЕсли;
		
		ПозицияСимвола = ПозицияСимвола - 1;	
	КонецЦикла;

	Возврат "";
  	
КонецФункции

// Выделяет из имени файла его расширение (набор символов после последней точки).
//
// Параметры
//  ИмяФайла     – Строка, содержащая имя файла, неважно с именем каталога или без.
//
// Возвращаемое значение:
//   Строка – расширение файла.
//
Функция ПолучитьРасширениеИмениФайла(Знач ИмяФайла) Экспорт
	
	Расширение = ПолучитьСтрокуОтделеннойСимволом(ИмяФайла, ".");
	Возврат Расширение;
	
КонецФункции

// Извлечь текст из файла и возвратить его в виде строки
//
Функция ИзвлечьТекст(ПолноеИмяФайла, Отказ = Ложь, Кодировка = Неопределено) Экспорт
	
	ИзвлеченныйТекст = "";
	
#Если Не ВебКлиент Тогда
	
	СписокРасширенийТекстовыхФайлов = "";
	#Если Сервер ИЛИ ВнешнееСоединение Тогда
		СписокРасширенийТекстовыхФайлов = ФайловыеФункцииСлужебныйПовтИсп.ПолучитьСписокРасширенийТекстовыхФайлов();
	#Иначе
		СписокРасширенийТекстовыхФайлов = ФайловыеФункцииСлужебныйКлиентПовтИсп.ПолучитьСписокРасширенийТекстовыхФайлов();
	#КонецЕсли
	
	РасширениеФайлаБезТочки = ПолучитьРасширениеИмениФайла(ПолноеИмяФайла);
	
	Если РасширениеФайлаВСписке(СписокРасширенийТекстовыхФайлов, РасширениеФайлаБезТочки) Тогда
		Отказ = Ложь;
		Возврат ИзвлечьТекстИзТекстовогоФайла(ПолноеИмяФайла, Кодировка);
	КонецЕсли;	
	
	Попытка
		Извлечение = Новый ИзвлечениеТекста(ПолноеИмяФайла);
		ИзвлеченныйТекст = Извлечение.ПолучитьТекст();
	Исключение
		// Ничего не пишем - это нормальная ситуация - когда Текст некому извлечь
		ИзвлеченныйТекст = "";
		Отказ = Истина;
	КонецПопытки;
#КонецЕсли

	Если ПустаяСтрока(ИзвлеченныйТекст) Тогда
	
		СписокРасширенийФайловOpenDocument = "";
	#Если Сервер ИЛИ ВнешнееСоединение Тогда
		СписокРасширенийФайловOpenDocument = ФайловыеФункцииСлужебныйПовтИсп.ПолучитьСписокРасширенийФайловOpenDocument();
	#Иначе
		СписокРасширенийФайловOpenDocument = ФайловыеФункцииСлужебныйКлиентПовтИсп.ПолучитьСписокРасширенийФайловOpenDocument();
	#КонецЕсли
	
		РасширениеФайлаБезТочки = ПолучитьРасширениеИмениФайла(ПолноеИмяФайла);
		
		Если РасширениеФайлаВСписке(СписокРасширенийФайловOpenDocument, РасширениеФайлаБезТочки) Тогда
			
			Отказ = Ложь;
			Возврат ИзвлечьТекстOpenDocument(ПолноеИмяФайла);
			
		КонецЕсли;
		
	КонецЕсли;	
	
	Возврат ИзвлеченныйТекст;
	
КонецФункции

// Извлекает текст в соответствии с кодировкой. 
// Если кодировка не задана - сама вычисляет кодировку
Функция ИзвлечьТекстИзТекстовогоФайла(ПолноеИмяФайла, Кодировка) 
	
	ИзвлеченныйТекст = "";
	
#Если Не ВебКлиент Тогда	
	
	// Определяем кодировку
	Если Не ЗначениеЗаполнено(Кодировка) Тогда
		Кодировка = Неопределено;
	КонецЕсли;
	
	ЧтениеТекста = Новый ЧтениеТекста(ПолноеИмяФайла, Кодировка);
	ИзвлеченныйТекст = ЧтениеТекста.Прочитать();
	
#КонецЕсли

	Возврат ИзвлеченныйТекст;
	
КонецФункции	

// Извлечь текст из файла OpenDocument и возвратить его в виде строки
//
Функция ИзвлечьТекстOpenDocument(ПутьКФайлу) Экспорт
	
	ИзвлеченныйТекст = "";
	
#Если Не ВебКлиент Тогда
	
	ВременнаяПапкаДляРазархивирования = ПолучитьИмяВременногоФайла("");
	ВременныйZIPФайл = ПолучитьИмяВременногоФайла("zip"); 
	
	КопироватьФайл(ПутьКФайлу, ВременныйZIPФайл);
	Файл = Новый Файл(ВременныйZIPФайл);
	Файл.УстановитьТолькоЧтение(Ложь);

	Попытка
		Архив = Новый ЧтениеZipФайла();
		Архив.Открыть(ВременныйZIPФайл);
		Архив.ИзвлечьВсе(ВременнаяПапкаДляРазархивирования, РежимВосстановленияПутейФайловZIP.Восстанавливать);
		Архив.Закрыть();
		ЧтениеXML = Новый ЧтениеXML();
		
		ЧтениеXML.ОткрытьФайл(ВременнаяПапкаДляРазархивирования + "/content.xml");
		ИзвлеченныйТекст = ИзвлечьТекстИзContentXML(ЧтениеXML);
		ЧтениеXML.Закрыть();
	Исключение
		// не считаем ошибкой, т.к. например расширение OTF может быть как OpenDocument, так и шрифт OpenType
		ИзвлеченныйТекст = "";
	КонецПопытки;
	
	УдалитьФайлы(ВременнаяПапкаДляРазархивирования);
	УдалитьФайлы(ВременныйZIPФайл);
	
#КонецЕсли
	
	Возврат ИзвлеченныйТекст;
	
КонецФункции

// Извлечь текст из объекта ЧтениеXML (прочитанного из файла OpenDocument)
Функция ИзвлечьТекстИзContentXML(ЧтениеXML)
	
	ИзвлеченныйТекст = "";
	ПоследнееИмяТега = "";
	
#Если Не ВебКлиент Тогда
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			ПоследнееИмяТега = ЧтениеXML.Имя;
			
			Если ЧтениеXML.Имя = "text:p" Тогда
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + Символы.ПС;
				КонецЕсли;
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "text:line-break" Тогда
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + Символы.ПС;
				КонецЕсли;
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "text:tab" Тогда
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + Символы.Таб;
				КонецЕсли;
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "text:s" Тогда
				
				СтрокаДобавки = " "; // пробел
				
				Если ЧтениеXML.КоличествоАтрибутов() > 0 Тогда
					Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
						Если ЧтениеXML.Имя = "text:c"  Тогда
							ЧислоПробелов = Число(ЧтениеXML.Значение);
							СтрокаДобавки = "";
							Для Индекс = 0 По ЧислоПробелов - 1 Цикл
								СтрокаДобавки = СтрокаДобавки + " "; // пробел
							КонецЦикла;
						КонецЕсли;
					КонецЦикла
				КонецЕсли;
				
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + СтрокаДобавки;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
			
			Если Найти(ПоследнееИмяТега, "text:") <> 0 Тогда
				ИзвлеченныйТекст = ИзвлеченныйТекст + ЧтениеXML.Значение;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
#КонецЕсли

	Возврат ИзвлеченныйТекст;
	
КонецФункции	

// Извлечь текст из файла и поместить во временное хранилище
//
Функция ИзвлечьТекстВоВременноеХранилище(ПолноеИмяФайла, УникальныйИдентификатор = "", Отказ = Ложь,
	Кодировка = Неопределено) Экспорт
	
	АдресВременногоХранилища = "";
	Отказ = Ложь;
	
#Если Не ВебКлиент Тогда
	
	Текст = ИзвлечьТекст(ПолноеИмяФайла, Отказ, Кодировка);
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат "";
	КонецЕсли;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ТекстовыйФайл = Новый ЗаписьТекста(ИмяВременногоФайла, КодировкаТекста.UTF8);
	ТекстовыйФайл.Записать(Текст);
	ТекстовыйФайл.Закрыть();
	
#Если Клиент Тогда
	ПоместитьФайл(АдресВременногоХранилища, ИмяВременногоФайла, , Ложь, УникальныйИдентификатор);
#Иначе
	Возврат Текст;
#КонецЕсли
	
	УдалитьФайлы(ИмяВременногоФайла);
	
#КонецЕсли
	
	Возврат АдресВременногоХранилища;
	
КонецФункции

// Получить уникальное имя файла в рабочем каталоге - если есть совпадения - будет имя типа A1\Приказ.doc
//
Функция ПолучитьУникальноеИмяСПутем(ИмяКаталога, ИмяФайла, ТипПлатформыТекущий) Экспорт 
	РезультирующийПуть = ""; 
	
	Счетчик = 0;
	ЦиклНомер = 0;
	Успешно = Ложь;
	
	ГенераторСлучая = Неопределено;
#Если Не ВебКлиент Тогда
	// ТекущаяДата() используется только для генерации случайного числа поэтому приведение к ТекущаяДатаСеанса не нужно	
	ГенераторСлучая = Новый ГенераторСлучайныхЧисел(Секунда(ТекущаяДата()));
#КонецЕсли
	
	Пока НЕ Успешно И ЦиклНомер < 100 Цикл
		НомерКаталога = 0;
#Если Не ВебКлиент Тогда
		НомерКаталога = ГенераторСлучая.СлучайноеЧисло(0, 25);
#Иначе
		// ТекущаяДата() используется только для генерации случайного числа поэтому приведение к ТекущаяДатаСеанса не нужно		
		НомерКаталога = Секунда(ТекущаяДата()) % 26;
#КонецЕсли
		
		КодБукваA = КодСимвола("A", 1); 
		КодКаталога = КодБукваA + НомерКаталога;
		
		БукваКаталога = Символ(КодКаталога);
		
		ПодКаталог = ""; // Частичный путь
		
		// По умолчанию вначале будет класть в корень, а уже потом, 
		//  если не сможет, то в A, B, ... Z,  A1, B1, .. Z1, ..  A2, B2 и т.д.
		Если  Счетчик = 0 Тогда
			ПодКаталог = "";
		Иначе
			ПодКаталог = БукваКаталога; 
			ЦиклНомер = Окр(Счетчик / 26);
			
			Если ЦиклНомер <> 0 Тогда
				ЦиклНомерСтрока = Строка(ЦиклНомер);
				ПодКаталог = ПодКаталог + ЦиклНомерСтрока;
			КонецЕсли;
			
			ПодКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПодКаталог, ТипПлатформыТекущий);  
		КонецЕсли;
		
		ПолныйПодКаталог = ИмяКаталога + ПодКаталог;  
		
		// Создать каталог для файлов
		КаталогНаДиске = Новый Файл(ПолныйПодКаталог);
		Если НЕ КаталогНаДиске.Существует() Тогда
			СоздатьКаталог(ПолныйПодКаталог);
		КонецЕсли;
		
		ФайлПопытки = ПолныйПодКаталог + ИмяФайла;
		Счетчик = Счетчик + 1;
		
		// Проверить, есть ли файл с таким именем
		ФайлНаДиске = Новый Файл(ФайлПопытки);
		Если НЕ ФайлНаДиске.Существует() Тогда  // нет такого файла
			РезультирующийПуть = ПодКаталог + ИмяФайла;
			Успешно = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат РезультирующийПуть;
КонецФункции

// Получить уникальное имя файла в рабочем каталоге - если есть совпадения - будет имя типа A1\Приказ.doc
//
Функция ПолучитьМассивУникальныхИменСПутем(ИмяКаталога, МассивГлавныйИПодчиненные, МассивПолныхИмен) Экспорт 
	
	Счетчик = 0;
	ЦиклНомер = 0;
	Успешно = Ложь;
	
	ГенераторСлучая = Неопределено;
	#Если Не ВебКлиент Тогда
		// ТекущаяДата() используется только для генерации случайного числа поэтому приведение к ТекущаяДатаСеанса не нужно
		ГенераторСлучая = Новый ГенераторСлучайныхЧисел(Секунда(ТекущаяДата()));
	#КонецЕсли
	
	Пока НЕ Успешно И ЦиклНомер < 100 Цикл
		НомерКаталога = 0;
		#Если Не ВебКлиент Тогда
			НомерКаталога = ГенераторСлучая.СлучайноеЧисло(0, 25);
		#Иначе
			// ТекущаяДата() используется только для генерации случайного числа поэтому приведение к ТекущаяДатаСеанса не нужно
			НомерКаталога = Секунда(ТекущаяДата()) % 26;
		#КонецЕсли
		
		КодБукваA = КодСимвола("A", 1); 
		КодКаталога = КодБукваA + НомерКаталога;
		
		БукваКаталога = Символ(КодКаталога);
		
		ПодКаталог = ""; // Частичный путь

		// По умолчанию вначале будет класть в корень, а уже потом, 
		//  если не сможет, то в A, B, ... Z,  A1, B1, .. Z1, ..  A2, B2 и т.д.
		Если  Счетчик = 0 Тогда
			ПодКаталог = "";
		Иначе
			ПодКаталог = БукваКаталога; 
			ЦиклНомер = Окр(Счетчик / 26);
			
			Если ЦиклНомер <> 0 Тогда
				ЦиклНомерСтрока = Строка(ЦиклНомер);
				ПодКаталог = ПодКаталог + ЦиклНомерСтрока;
			КонецЕсли;
			
			ПодКаталог = ПодКаталог + "\";  
		КонецЕсли;

		ПолныйПодКаталог = ИмяКаталога + ПодКаталог;  

		
		МассивПолныхИмен.Очистить();
		Успешно = Истина;
		
		Для Каждого ИмяИПуть Из МассивГлавныйИПодчиненные Цикл
			
			ФайлПопытки = ПолныйПодКаталог + ИмяИПуть;
			
			// Проверить, есть ли файл с таким именем
			ФайлНаДиске = Новый Файл(ФайлПопытки);
			
			Если НЕ ФайлНаДиске.Существует() Тогда  // нет такого файла
				
				// Создать каталог для файлов
				СоздатьКаталог(ФайлНаДиске.Путь);
				
				РезультирующийПуть = ПодКаталог + ИмяИПуть;
				МассивПолныхИмен.Добавить(РезультирующийПуть);
			Иначе	
				МассивПолныхИмен.Очистить();
				Успешно = Ложь;
				Прервать; // выход из цикла подчиненных файлов
			КонецЕсли;

		КонецЦикла;	
		
		
		Счетчик = Счетчик + 1;
		
	КонецЦикла;
	
	Возврат Успешно;	
КонецФункции

// Вернет Истина если файл можно загружать (размер не превышает максимальный, расширение не запрещено)
//
Функция ФайлМожноЗагружать(ВыбранныйФайл,
				МаксРазмерФайла,
				ЗапретЗагрузкиФайловПоРасширению,
				СписокЗапрещенныхРасширений,
				МассивИменФайловСОшибками) Экспорт
	
	// Размер файла слишком большой
	Если ВыбранныйФайл.Размер() > МаксРазмерФайла Тогда
		
		РазмерВМб = ВыбранныйФайл.Размер() / (1024 * 1024);
		РазмерВМбМакс = МаксРазмерФайла / (1024 * 1024);
		
		Запись = Новый Структура;
		Запись.Вставить("ИмяФайла", ВыбранныйФайл.ПолноеИмя);
		Запись.Вставить("Ошибка", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Размер файла (%1 Мб) превышает максимальный размер файла: (%2 Мб)'"),
						ПолучитьСтрокуСРазмеромФайла(РазмерВМб), 
						ПолучитьСтрокуСРазмеромФайла(РазмерВМбМакс)
						)); 
		МассивИменФайловСОшибками.Добавить(Запись);
		
		Возврат Ложь;
	КонецЕсли;
	
	// расширение файла в списке запрещенных
	РасширениеФайла = ВыбранныйФайл.Расширение;
	Если Не РасширениеФайлаРазрешеноДляЗагрузки(ЗапретЗагрузкиФайловПоРасширению, СписокЗапрещенныхРасширений, РасширениеФайла) Тогда
		
		Запись = Новый Структура;
		Запись.Вставить("ИмяФайла", ВыбранныйФайл.ПолноеИмя);
		Запись.Вставить("Ошибка", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Загрузка файлов с расширением ""%1"" запрещена. Обратитесь к администратору системы.'"),
				 РасширениеФайла));
		МассивИменФайловСОшибками.Добавить(Запись);
		
		Возврат Ложь;
	КонецЕсли;
	
	// временные файлы Word не импортируем
	Если Лев(ВыбранныйФайл.Имя, 1) = "~" И ВыбранныйФайл.ПолучитьНевидимость() = Истина Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Возвращает Истина, если файл с таким расширением можно загружать
//
Функция РасширениеФайлаРазрешеноДляЗагрузки(ЗапретЗагрузкиФайловПоРасширению, СписокЗапрещенныхРасширений, РасширениеФайла) Экспорт
	
	Если ЗапретЗагрузкиФайловПоРасширению = Ложь Тогда
		Возврат Истина;
	КонецЕсли;
	
	РасширениеФайлаБезТочки = РасширениеФайла;
	
	Если Лев(РасширениеФайлаБезТочки, 1) = "." Тогда
		РасширениеФайлаБезТочки = Сред(РасширениеФайлаБезТочки, 2);
	КонецЕсли;
	
	Расширение = НРег(РасширениеФайлаБезТочки);
	СписокЗапрещенныхРасширенийНижнийРегистр = НРег(СписокЗапрещенныхРасширений);
	
	МассивРасширений = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
		СписокЗапрещенныхРасширенийНижнийРегистр, " ");
	
	Если МассивРасширений.Найти(Расширение) <> Неопределено Тогда // нашли в массиве
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// удаляет файлы после импорта или загрузки
Процедура УдалитьФайлыПослеДобавления(МассивСтруктурВсехФайлов, МассивВсехПапок, РежимЗагрузки) Экспорт
	
	Для Каждого Элемент Из МассивСтруктурВсехФайлов Цикл
		ВыбранныйФайл = Новый Файл(Элемент.ИмяФайла);
		ВыбранныйФайл.УстановитьТолькоЧтение(Ложь);
		УдалитьФайлы(ВыбранныйФайл.ПолноеИмя);
	КонецЦикла;
	
	Если РежимЗагрузки Тогда
		Для Каждого Элемент Из МассивВсехПапок Цикл
			НайденныеФайлы = НайтиФайлы(Элемент, "*.*");
			Если НайденныеФайлы.Количество() = 0 Тогда
				ВыбранныйФайл = Новый Файл(Элемент);
				ВыбранныйФайл.УстановитьТолькоЧтение(Ложь);
				УдалитьФайлы(ВыбранныйФайл.ПолноеИмя);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры	

// Функция предназначена для преобразования расширения файла в следующий вид: без точки и в нижнем регистре
// Параметры:
//  СтрРасширение - Строка. Расширение для преобразования
// Возвращаемое значение:
//  Преобразованная Строка
Функция РасширениеБезТочки(СтрРасширение) Экспорт
	
	Расширение = НРег(СокрЛП(СтрРасширение));
	
	Если Сред(Расширение, 1, 1) = "." Тогда
		Расширение = Сред(Расширение, 2);
	КонецЕсли;
	
	Возврат Расширение;
	
КонецФункции // РасширениеБезТочки()

// Возвращает массив файлов, эмулируя работу НайтиФайлы - но не по файловой системе, а по Соответствию
//  если ПсевдоФайловаяСистема пуста - работает с файловой системой
Функция НайтиФайлыПсевдо(Знач ПсевдоФайловаяСистема, Путь) Экспорт
	Если ПсевдоФайловаяСистема.Количество() = 0 Тогда
		Файлы = НайтиФайлы(Путь, "*.*");
		Возврат Файлы;
	КонецЕсли;
	
	Файлы = Новый Массив;
	
	ЗначениеНайденное = ПсевдоФайловаяСистема.Получить(Строка(Путь));
	Если ЗначениеНайденное <> Неопределено Тогда
		Для Каждого ИмяФайла Из ЗначениеНайденное Цикл
			Попытка
				ФайлИзСписка = Новый Файл(ИмяФайла);
				Файлы.Добавить(ФайлИзСписка);
			Исключение
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Файлы;
КонецФункции

// Функция раскладывает строку в массив строк, используя "./\" как разделитель
//
Функция РазложитьСтрокуПоТочкамИСлэшам(Знач Представление) Экспорт
	
	Перем ТекущаяПозиция;
	
	Фрагменты = Новый Массив;
	
	НачальнаяПозиция = 1;
	
	Для ТекущаяПозиция = 1 По СтрДлина(Представление) Цикл
		ТекущийСимвол = Сред(Представление, ТекущаяПозиция, 1);
		Если ТекущийСимвол = "." Или ТекущийСимвол = "/" Или ТекущийСимвол = "\" Тогда
			ТекущийФрагмент = Сред(Представление, НачальнаяПозиция, ТекущаяПозиция - НачальнаяПозиция);
			НачальнаяПозиция = ТекущаяПозиция + 1;
			Фрагменты.Добавить(ТекущийФрагмент);
		КонецЕсли;
	КонецЦикла;
	
	Если НачальнаяПозиция <> ТекущаяПозиция Тогда
		ТекущийФрагмент = Сред(Представление, НачальнаяПозиция, ТекущаяПозиция - НачальнаяПозиция);
		Фрагменты.Добавить(ТекущийФрагмент);
	КонецЕсли;
	
	Возврат Фрагменты;
	
КонецФункции

// Получается индекс пиктограммы файла - индекс в картинке КоллекцияПиктограммФайлов
//
Функция ПолучитьИндексПиктограммыФайла(Знач РасширениеФайлаТолькоТекст) Экспорт
	
	Если РасширениеФайлаТолькоТекст = Неопределено Тогда
		Возврат 0;
	КонецЕсли;		
	
	РасширениеФайлаБезТочки = РасширениеФайлаТолькоТекст;
	
	Если Лев(РасширениеФайлаБезТочки, 1) = "." Тогда
		РасширениеФайлаБезТочки = Сред(РасширениеФайлаБезТочки, 2);
	КонецЕсли;
	
	Расширение = "." + НРег(РасширениеФайлаБезТочки) + ";";
	
	Если Найти(".dt;.1cd;.cf;.cfu;",Расширение) <> 0 Тогда
		Возврат 6; //Файлы 1С
	ИначеЕсли Расширение = ".mxl;" Тогда
		Возврат 8; //Табличный Файл 
	ИначеЕсли Найти(".txt;.log;.ini;",Расширение) <> 0 Тогда
		Возврат 10; // Текстовый Файл
	ИначеЕсли Расширение = ".epf;" Тогда
		Возврат 12; //Внешние обработки
	ИначеЕсли Найти(".ico;.wmf;.emf;",Расширение) <> 0 Тогда
		Возврат 14; // Картинки
	ИначеЕсли Найти(".htm;.html;.url;.mht;.mhtml;",Расширение) <> 0 Тогда
		Возврат 16; // HTML
	ИначеЕсли Найти(".doc;.dot;.rtf;",Расширение) <> 0 Тогда
		Возврат 18; // Файл Microsoft Word 
	ИначеЕсли Найти(".xls;.xlw;",Расширение) <> 0 Тогда
		Возврат 20; // Файл Microsoft Excel
	ИначеЕсли Найти(".ppt;.pps;",Расширение) <> 0 Тогда
		Возврат 22; // Файл Microsoft PowerPoint
	ИначеЕсли Найти(".vsd;",Расширение) <> 0 Тогда
		Возврат 24; // Файл Microsoft Visio
	ИначеЕсли Найти(".mpp;",Расширение) <> 0 Тогда
		Возврат 26; // Файл Microsoft Visio
	ИначеЕсли Найти(".mdb;.adp;.mda;.mde;.ade;",Расширение) <> 0 Тогда
		Возврат 28; // База данных Microsoft Access
	ИначеЕсли Найти(".xml;",Расширение) <> 0 Тогда
		Возврат 30; // xml
	ИначеЕсли Найти(".msg;",Расширение) <> 0 Тогда
		Возврат 32; // Письмо электронной почты
	ИначеЕсли Найти(".zip;.rar;.arj;.cab;.lzh;.ace;",Расширение) <> 0 Тогда
		Возврат 34; // Архивы
	ИначеЕсли Найти(".exe;.com;.bat;.cmd;",Расширение) <> 0 Тогда
		Возврат 36; // Исполняемые файлы
	ИначеЕсли Найти(".grs;",Расширение) <> 0 Тогда
		Возврат 38; // Графическая схема
	ИначеЕсли Найти(".geo;",Расширение) <> 0 Тогда
		Возврат 40; // Географическая схема
	ИначеЕсли Найти(".jpg;.jpeg;.jp2;.jpe;",Расширение) <> 0 Тогда
		Возврат 42; // jpg
	ИначеЕсли Найти(".bmp;.dib;",Расширение) <> 0 Тогда
		Возврат 44; // bmp
	ИначеЕсли Найти(".tif;.tiff;",Расширение) <> 0 Тогда
		Возврат 46; // tif
	ИначеЕсли Найти(".gif;",Расширение) <> 0 Тогда
		Возврат 48; // gif
	ИначеЕсли Найти(".png;",Расширение) <> 0 Тогда
		Возврат 50; // png
	ИначеЕсли Найти(".pdf;",Расширение) <> 0 Тогда
		Возврат 52; // pdf
	ИначеЕсли Найти(".odt;",Расширение) <> 0 Тогда
		Возврат 54; // Open Office writer
	ИначеЕсли Найти(".odf;",Расширение) <> 0 Тогда
		Возврат 56; // Open Office math
	ИначеЕсли Найти(".odp;",Расширение) <> 0 Тогда
		Возврат 58; // Open Office Impress
	ИначеЕсли Найти(".odg;",Расширение) <> 0 Тогда
		Возврат 60; // Open Office draw
	ИначеЕсли Найти(".ods;",Расширение) <> 0 Тогда
		Возврат 62; // Open Office calc
	ИначеЕсли Найти(".mp3;",Расширение) <> 0 Тогда
		Возврат 64;
	ИначеЕсли Найти(".erf;",Расширение) <> 0 Тогда
		Возврат 66; // Внешние отчеты
	ИначеЕсли Найти(".docx;",Расширение) <> 0 Тогда
		Возврат 68; // Файл Microsoft Word docx
	ИначеЕсли Найти(".xlsx;",Расширение) <> 0 Тогда
		Возврат 70; // Файл Microsoft Excel xlsx
	ИначеЕсли Найти(".pptx;",Расширение) <> 0 Тогда
		Возврат 72; // Файл Microsoft PowerPoint pptx
	Иначе
		Возврат 4;
	КонецЕсли;
	
КонецФункции // ()

// Возвращает имя с расширением- если расширение пусто - только имя
//
Функция ПолучитьИмяСРасширением(ПолноеНаименование, Расширение) Экспорт
	
	ИмяСРасширением = ПолноеНаименование;
	
	Если Расширение <> "" Тогда
		ИмяСРасширением = ИмяСРасширением + "." + Расширение;
	КонецЕсли;
	
	Возврат ИмяСРасширением;
	
КонецФункции

// Функция пытается по переданным именам файлов сделать сопоставление
// на файлы данных и файлы их подписей.
// Сопоставление происходит на основе правила формирования имени подписи,
// и расширения файла подписи (p7s)
// Например:
//	Имя файла данных:  example.txt
//	имя файла подписи: example-Ivanov Petr.p7s
//	имя файла подписи: example-Ivanov Petr (1).p7s
//
// Возвращает соответствие, в котором:
// ключ - имя файла
// значение - массив найденных соответствий - подписей
// 
Функция ПолучитьСоответствиеФайловИПодписей(ИменаФайлов, РасширениеДляФайловПодписи) Экспорт
	
	Результат = Новый Соответствие;
	
	// разделяем файлы по расширению
	ИменаФайловДанных = Новый Массив;
	ИменаФайловПодписей = Новый Массив;
	
	Для Каждого ИмяФайла Из ИменаФайлов Цикл
		Если Прав(ИмяФайла, 3) = РасширениеДляФайловПодписи Тогда
			ИменаФайловПодписей.Добавить(ИмяФайла);
		Иначе
			ИменаФайловДанных.Добавить(ИмяФайла);
		КонецЕсли;
	КонецЦикла;
	
	// отсортируем имена файлов данных по убыванию числа символов в строке
	
	Для ИндексА = 1 По ИменаФайловДанных.Количество() Цикл
		ИндексМАКС = ИндексА; // считаем что текущий файл имеет самое большое число символов
		Для ИндексБ = ИндексА+1 По ИменаФайловДанных.Количество() Цикл
			Если СтрДлина(ИменаФайловДанных[ИндексМАКС-1]) > СтрДлина(ИменаФайловДанных[ИндексБ-1]) Тогда
				ИндексМАКС = ИндексБ;
			КонецЕсли;
		КонецЦикла;
		своп = ИменаФайловДанных[ИндексА-1];
		ИменаФайловДанных[ИндексА-1] = ИменаФайловДанных[ИндексМАКС-1];
		ИменаФайловДанных[ИндексМАКС-1] = своп;
	КонецЦикла;
	
	// поиск соответствий имен файлов
	Для Каждого ИмяФайлаДанных Из ИменаФайловДанных Цикл
		Результат.Вставить(ИмяФайлаДанных, НайтиИменаФайловПодписей(ИмяФайлаДанных, ИменаФайловПодписей));
	КонецЦикла;
	
	// оставшиеся файлы подписей не распознаны как подписи относящиеся к какому то файлу
	Для Каждого ИмяФайлаПодписи Из ИменаФайловПодписей Цикл
		Результат.Вставить(ИмяФайлаПодписи, Новый Массив);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция НайтиИменаФайловПодписей(ИмяФайлаДанных, ИменаФайловПодписей)
	
	ИменаПодписей = Новый Массив;
	
	Файл = Новый Файл(ИмяФайлаДанных);
	ИмяБезРасширения = Файл.ИмяБезРасширения;
	
	Для Каждого ИмяФайлаПодписи Из ИменаФайловПодписей Цикл
		Если Найти(ИмяФайлаПодписи, ИмяБезРасширения) > 0 Тогда
			ИменаПодписей.Добавить(ИмяФайлаПодписи);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ИмяФайлаПодписи Из ИменаПодписей Цикл
		ИменаФайловПодписей.Удалить(ИменаФайловПодписей.Найти(ИмяФайлаПодписи));
	КонецЦикла;
	
	Возврат ИменаПодписей;
	
КонецФункции

// Функции - текстовые сообщения

 // Возвращает текст сообщения об ошибке создания нового файла.
//
// Параметры:
//  ИнформацияОбОшибке - ИнформацияОбОшибке.
//
Функция ОшибкаСозданияНовогоФайла(ИнформацияОбОшибке) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Ошибка создания нового файла.
		           |
		           |%1'"),
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке));

КонецФункции

// Получить строку с представлением размера файла - например для отображения в Состояние при передаче файла
Функция ПолучитьСтрокуСРазмеромФайла(Знач РазмерВМб) Экспорт
	
	Если РазмерВМб < 0.1 Тогда
		РазмерВМб = 0.1;
	КонецЕсли;	
	
	СтрокаРазмера = ?(РазмерВМб >= 1, Формат(РазмерВМб, "ЧДЦ=0"), Формат(РазмерВМб, "ЧДЦ=1; ЧН=0"));
	Возврат СтрокаРазмера;
	
КонецФункции	

// Получает символ слэша "\" или "/"
Функция ПолучитьСлеш(ТипПлатформыТекущий) Экспорт
	
	Если ТипПлатформыТекущий = ТипПлатформы.Windows_x86 ИЛИ ТипПлатформыТекущий = ТипПлатформы.Windows_x86_64 Тогда
		Возврат "\";
	Иначе	
		Возврат "/";
	КонецЕсли;			
	
КонецФункции

// Возвращает Истина, если файл с таким расширением находится в списке расширений
Функция РасширениеФайлаВСписке(СписокРасширений, РасширениеФайла) Экспорт
	
	РасширениеФайлаБезТочки = РасширениеФайла;
	
	Если Лев(РасширениеФайлаБезТочки, 1) = "." Тогда
		РасширениеФайлаБезТочки = Сред(РасширениеФайлаБезТочки, 2);
	КонецЕсли;
	
	Расширение = НРег(РасширениеФайлаБезТочки);
	СписокРасширенийНижнийРегистр = НРег(СписокРасширений);
	
	МассивРасширений = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
		СписокРасширенийНижнийРегистр, " ");
	
	Если МассивРасширений.Найти(Расширение) <> Неопределено Тогда // Нашли в массиве
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции
