﻿&НаКлиенте
Процедура ВыгрузитьВыполнить()
	#Если НЕ ВебКлиент Тогда
		// Проверим - каталог выгрузки существует? если нет - создадим
		КаталогВыгрузки = Новый Файл(ПапкаДляЭкспортаПолная);
		
		Если не КаталогВыгрузки.Существует() Тогда
			
			Попытка
				
				СоздатьКаталог(ПапкаДляЭкспортаПолная);
				
			Исключение
				
				ИнфоОшибка = ИнформацияОбОшибке();
				Предупреждение(НСтр("ru = 'Не удалось создать папку выгрузки.'") + Символы.ВК + НСтр("ru = 'Причина:'") + ИнфоОшибка.Описание);
				Возврат;
				
			КонецПопытки;
			
		КонецЕсли;
		
		Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Выполняется экспорт папки ""%1""...
									|Пожалуйста, подождите.'"),
						Строка(ЧтоСохраняем) ));
		
		// Получим список выгружаемых файлов
		СформироватьДеревоФайлов(ЧтоСохраняем);
		
		// Заранее создадим форму, чтобы потом не тратить на это время
		ФормаВопроса = РаботаСФайламиКлиентПовтИсп.ПолучитьФормуЭкспортаПапкиФайлСуществует();
		
		// А теперь начнем выгрузку
		ЕщеНеВстретилиВыгружаемуюПапку = Истина;
		Успех = ОбойтиДеревоФайлов(ФормаВопроса, ДеревоФайлов, ПапкаДляЭкспортаПолная, Ложь, "", ЕщеНеВстретилиВыгружаемуюПапку, ЧтоСохраняем);
		
		Если Успех Тогда
			СохраняемыйПуть = ПапкаДляЭкспорта;
			ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ИмяПапкиВыгрузки", "ИмяПапкиВыгрузки",  СохраняемыйПуть);
			
			Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			             НСтр("ru = 'Экспорт папки ""%1"" в каталог на диске ""%2"" успешно завершен.'"),
			             Строка(ЧтоСохраняем), Строка(ПапкаДляЭкспорта) ) );
			
			Закрыть();
			
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПапкаДляЭкспортаПриИзменении(Элемент)
	
	ПапкаДляЭкспорта = ФайловыеФункцииСлужебныйКлиент.НормализоватьКаталог(
		ПапкаДляЭкспорта);
	
	ПапкаДляЭкспортаПолная = ФайловыеФункцииСлужебныйКлиент.НормализоватьКаталог(
		ПапкаДляЭкспортаПолная);
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкаДляЭкспортаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

#Если НЕ ВебКлиент Тогда
	
	// Открытие окна выбора папки сохранения.
	СтандартнаяОбработка = Ложь;
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ВыборФайла.МножественныйВыбор = Ложь;
	ВыборФайла.Каталог = ПапкаДляЭкспорта;
	Если ВыборФайла.Выбрать() Тогда
		
		ПапкаДляЭкспорта = ФайловыеФункцииСлужебныйКлиент.НормализоватьКаталог(
			ВыборФайла.Каталог);
		
		ПапкаДляЭкспортаПолная =
			  ПапкаДляЭкспорта
			+ Строка(ЧтоСохраняем)
			+ ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьСлеш(
				ОбщегоНазначенияКлиентПовтИсп.ТипПлатформыКлиента());
		
	КонецЕсли;
	
#КонецЕсли

КонецПроцедуры

&НаСервере
Процедура ПриСоздании(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ПапкаЭкспорта <> Неопределено Тогда
		ЧтоСохраняем = Параметры.ПапкаЭкспорта;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоФайлов(ПапкаРодитель)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	Файлы.ВладелецФайла КАК Папка,
	               |	Файлы.ВладелецФайла.Наименование КАК НаименованиеПапки,
	               |	Файлы.ТекущаяВерсия,
	               |	Файлы.ПолноеНаименование КАК ПолноеНаименование,
	               |	Файлы.ТекущаяВерсия.Расширение КАК Расширение,
	               |	Файлы.ТекущаяВерсия.Размер КАК Размер,
	               |	Файлы.ТекущаяВерсия.ДатаМодификацииУниверсальная КАК ДатаМодификацииУниверсальная,
	               |	Файлы.Ссылка,
	               |	Файлы.ПометкаУдаления
	               |ИЗ
	               |	Справочник.Файлы КАК Файлы
	               |ГДЕ
	               |	Файлы.ВладелецФайла В ИЕРАРХИИ(&Ссылка)
	               |	И Файлы.ТекущаяВерсия <> ЗНАЧЕНИЕ(Справочник.ВерсииФайлов.ПустаяСсылка)
	               |	И Файлы.ПометкаУдаления = ЛОЖЬ
	               |ИТОГИ ПО
	               |	Папка ИЕРАРХИЯ";
	Запрос.Параметры.Вставить("Ссылка", ПапкаРодитель);
	Результат = Запрос.Выполнить();
	ТаблицаВыгрузки = Результат.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	ЗначениеВРеквизитФормы(ТаблицаВыгрузки, "ДеревоФайлов");
КонецПроцедуры

// Рекурсивная функция, которая собственно и выгружает файлы на локальный диск
//
// Параметры:
//  ФормаВопроса - объект типа "УправляемаяФорма", который содержит ссылку на
//                 созданную в памяти форму вопроса о перезаписи файла с флажком
//                 "Для всех". Создается для того, чтобы не тратить время на
//                 регулярное создание формы внутри рекурсивного цикла.
//  ТаблицаФайлов - дерево значений с выгружаемыми файлами.
//  БазовыйКаталогСохранения - строка с именем папки, в которую сохраняются файлы.
//                 В ней воссоздается структура папок (как в дереве файлов)
//                 при необходимости.
//  ДляВсехФайлов - тип Булево
//                 Истина: пользователь выбрал действие при перезаписи файла и
//                 установил флажок "Для всех". Больше вопросов не задаем.
//                 Ложь: в каждом случае существования файла на диске, с тем же
//                 именем, что и в информационной базе будем задавать вопрос.
//  БазовоеДействия - тип КодВозвратаДиалога
//                 при выполнении одного действия для всех конфликтов при
//                 записи файла (параметр ДляВсехФайлов = Истина) выполняется
//                 действие, заданное этим параметром).
//                 .Да - перезаписать
//                 .Пропустить - пропустить файл
//                 .Прервать - прервать выгрузку
//
// Возвращаемое значение:
//  Истина       - можно продолжать выгрузку / выгрузка завершена успешно
//  Ложь         - действие завершено с ошибками / выгрузка завершена с ошибками
&НаКлиенте
Функция ОбойтиДеревоФайлов(ФормаВопроса, ТаблицаФайлов, Знач БазовыйКаталогСохранения, ДляВсехФайлов = Ложь, БазовоеДействие = "", ЕщеНеВстретилиВыгружаемуюПапку, РодительскаяПапка)
	#Если НЕ ВебКлиент Тогда
	
		Если БазовоеДействие = "" Тогда
			// По умолчанию сделаем минимальный вред
			БазовоеДействие = КодВозвратаДиалога.Пропустить;
		КонецЕсли;
		
		Для Каждого ЗаписьФайла из ТаблицаФайлов.ПолучитьЭлементы() Цикл
			
			Если ЕщеНеВстретилиВыгружаемуюПапку = Истина Тогда
				Если ЗаписьФайла.Папка = ЧтоСохраняем Тогда
					ЕщеНеВстретилиВыгружаемуюПапку = Ложь;
				КонецЕсли;
			КонецЕсли;
			
			Если ЕщеНеВстретилиВыгружаемуюПапку = Истина Тогда
				Если Не ОбойтиДеревоФайлов(ФормаВопроса, ЗаписьФайла, БазовыйКаталогСохранения, ДляВсехФайлов, БазовоеДействие, ЕщеНеВстретилиВыгружаемуюПапку, ЗаписьФайла.Папка) Тогда
					Возврат Ложь;
				КонецЕсли;
				
				Продолжить;
			КонецЕсли;
			
			// Сформируем путь к каталогу и пойдем дальше. Создавать каталоги будем
			БазовыйКаталогСохраненияФайла = БазовыйКаталогСохранения;
			Если (ЗаписьФайла.Папка <> ЧтоСохраняем) И ЗаписьФайла.ТекущаяВерсия.Пустая() Тогда
				Если РодительскаяПапка <> ЗаписьФайла.Папка Тогда
					БазовыйКаталогСохраненияФайла = БазовыйКаталогСохраненияФайла + ЗаписьФайла.НаименованиеПапки + ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьСлеш(ОбщегоНазначенияКлиентПовтИсп.ТипПлатформыКлиента());
				КонецЕсли;
			КонецЕсли;
			
			// Проверим наличие базового каталога: если нет - создадим
			Папка = Новый Файл(БазовыйКаталогСохраненияФайла);
			Если Не Папка.Существует() Тогда
				Пока Истина Цикл
					Попытка
						СоздатьКаталог(БазовыйКаталогСохраненияФайла);
						Прервать;
					Исключение
						// По какой-то причине каталог не создался ...
						инфоОшибка = ИнформацияОбОшибке();
						
						стрТекст =
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						     НСтр("ru = 'Ошибка создания папки ""%1"".
						                |Причина: %2'"),
						     БазовыйКаталогСохраненияФайла,
						     ?(инфоОшибка.Причина = Неопределено, "Неопределено", инфоОшибка.Причина.Описание) );
						
						Результат = Вопрос(стрТекст, РежимДиалогаВопрос.ПрерватьПовторитьПропустить, , КодВозвратаДиалога.Повторить);
						Если Результат = КодВозвратаДиалога.Прервать Тогда
							// Просто выйдем с ошибкой
							Возврат Ложь;
						ИначеЕсли Результат = КодВозвратаДиалога.Пропустить Тогда
							// Пропустим данную ветку дерева и пойдем дальше
							Возврат Истина;
						Иначе
							// Попробуем повторить создание папки
							Продолжить;
						КонецЕсли;
					КонецПопытки;
				КонецЦикла;
			КонецЕсли;
			
			
			// только в том случае, если в этой папке есть хоть один файл
			ДочерниеЭлементы = ЗаписьФайла.ПолучитьЭлементы();
			Если ДочерниеЭлементы.Количество() <> 0 Тогда
				имяГруппы = БазовыйКаталогСохраненияФайла;
				Если Не ОбойтиДеревоФайлов(ФормаВопроса, ЗаписьФайла, имяГруппы, ДляВсехФайлов, БазовоеДействие, ЕщеНеВстретилиВыгружаемуюПапку, ЗаписьФайла.Папка) Тогда
					Возврат Ложь;
				КонецЕсли;
			КонецЕсли;
			
			Если ЗаписьФайла.ТекущаяВерсия <> NULL и ЗаписьФайла.ТекущаяВерсия.Пустая() Тогда
				// Это элемент справочника Файлы без файла - пропустим
				Продолжить;
			КонецЕсли;
			
			// Пишем файл в базовый каталог
			ИмяФайлаСРасширением = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьИмяСРасширением(ЗаписьФайла.ПолноеНаименование, ЗаписьФайла.Расширение);
			
			ПолноеИмяФайла = БазовыйКаталогСохраненияФайла + ИмяФайлаСРасширением;
			
			// Проверка возможности записи файла
			Результат = КодВозвратаДиалога.Отмена;
			Пока Истина Цикл
				ФайлНаДиске = Новый Файл(ПолноеИмяФайла);
				Если ФайлНаДиске.Существует() и ФайлНаДиске.ЭтоКаталог() Тогда
					ТекстВопроса =
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					  НСтр("ru = 'Вместо файла ""%1""  существует папка с таким же именем. Повторить экспорт этого файла?'"),
					  ПолноеИмяФайла );
					
					Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ПовторитьОтмена, ,КодВозвратаДиалога.Отмена);
					Если Результат = КодВозвратаДиалога.Повторить Тогда
						
						// Данный файл игнорируем
						Продолжить;
					КонецЕсли;
				Иначе
					
					// Файла нет - идем дальше
					Результат = КодВозвратаДиалога.Повторить;
				КонецЕсли;
				Прервать;
			КонецЦикла;
			Если Результат = КодВозвратаДиалога.Отмена Тогда
				
				// Игнорируем файл с именем как у папки
				Продолжить;
			КонецЕсли;
			Результат = КодВозвратаДиалога.Нет;
			
			// Спросим, а что делать с текущим файлом
			Если ФайлНаДиске.Существует() Тогда
				
				// Если у файла стоит R|O и время изменения меньше, чем в информационной базе - просто перепишем
				Если ФайлНаДиске.ПолучитьТолькоЧтение() и ФайлНаДиске.ПолучитьВремяИзменения() <= ЗаписьФайла.ДатаМодификацииУниверсальная Тогда
					Результат = КодВозвратаДиалога.Да;
				Иначе
					Если Не ДляВсехФайлов Тогда
						Текст = 
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						      НСтр("ru = 'В папке ""%1""
						                 |существует файл ""%2""
						                 |размер существующего файла = %3 байт, дата изменения %4.
						                 |размер сохраняемого файла = %5 байт, дата изменения %6.
						                 |Перезаписать существующий файл файлом из системы?'"),
						      БазовыйКаталогСохраненияФайла,
						      ИмяФайлаСРасширением,
						      ФайлНаДиске.Размер(),
						      ФайлНаДиске.ПолучитьВремяИзменения(),
						      ЗаписьФайла.Размер,
						      ЗаписьФайла.ДатаМодификацииУниверсальная );
							  
							  
						СтруктураПараметров = Новый Структура("ТекстСообщения, ПрименитьДляВсех, БазовоеДействие", 
							Текст, ДляВсехФайлов, БазовоеДействие);
						ФормаВопроса.УстановитьПараметрыИспользования(СтруктураПараметров);	  
						
						// Да - перезаписать
						// Пропустить - пропустить файл
						// Прервать - прервать выгрузку
						РезультатДиалога = ФормаВопроса.ОткрытьМодально();
						Результат = РезультатДиалога.КодВозврата;
						ДляВсехФайлов = РезультатДиалога.ПрименитьДляВсех;
						БазовоеДействие = Результат;
					Иначе
						Результат = БазовоеДействие;
					КонецЕсли;
					Если Результат = КодВозвратаДиалога.Прервать Тогда
						
						// Прерываем выгрузку
						Возврат Ложь;
					ИначеЕсли Результат = КодВозвратаДиалога.Пропустить Тогда
						
						// Пропускаем этот файл
						Продолжить;
					КонецЕсли;
				КонецЕсли;
			Иначе
				
				// Файла нет, спрашивать не будем
				Результат = КодВозвратаДиалога.Да;
			КонецЕсли;
			
			// Если можно - запишем файл в файловую систему
			Если Результат = КодВозвратаДиалога.Да Тогда
				Пока Истина Цикл
					Попытка
						ФайлНаДиске = Новый Файл(ПолноеИмяФайла);
						Если ФайлНаДиске.Существует() Тогда
							
							// Снимем флаг R|O для возможности удаления
							ФайлНаДиске.УстановитьТолькоЧтение(Ложь);
						КонецЕсли;
						
						// Всегда удалим и потом создадим заново
						УдалитьФайлы(ПолноеИмяФайла);
						
						РазмерВМб = ЗаписьФайла.Размер / (1024 * 1024);
						
						// Обновим индикатор прогресса
						НадписьПодробнее =
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Сохраняется на диск файл ""%1"" (%2 Мб)...'"),
							ФайлНаДиске.Имя,
							ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьСтрокуСРазмеромФайла(РазмерВМб) );
						
						Состояние(
							СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						    	НСтр("ru = 'Экспорт папки ""%1""'"), ЗаписьФайла.НаименованиеПапки),
							,
							НадписьПодробнее, 
							БиблиотекаКартинок.Информация32);
						
						// Запишем файл заново
						стрАдрес = РаботаСФайламиВызовСервера.ПолучитьНавигационнуюСсылкуДляОткрытия(ЗаписьФайла.ТекущаяВерсия, УникальныйИдентификатор);
						ПолучитьФайл(стрАдрес, ПолноеИмяФайла, Ложь);
						
						// для варианта с хранением файлов на диске (на сервере) удаляем файл из временного хранилища после получения
						Если ЭтоАдресВременногоХранилища(стрАдрес) Тогда
							УдалитьИзВременногоХранилища(стрАдрес);
						КонецЕсли;
						
						ФайлНаДиске = Новый Файл(ПолноеИмяФайла);
						
						// Сделаем файл только для чтения
						ФайлНаДиске.УстановитьТолькоЧтение(Истина);
						
						ДатаСоздаваемогоФайлаНаДиске = ЗаписьФайла.ДатаМодификацииУниверсальная;
						ДатаСоздаваемогоФайлаНаДиске = МестноеВремя(ДатаСоздаваемогоФайлаНаДиске);
						
						// Поставим время модифицикации - как в информационной базе
						ФайлНаДиске.УстановитьВремяИзменения(ДатаСоздаваемогоФайлаНаДиске);
						Прервать;
					Исключение
						
						// По какой-то случилась файловая ошибка при записи файла и изменении его атрибутов ...
						инфоОшибка = ИнформацияОбОшибке();
						стрТекст =
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						  НСтр("ru = 'Ошибка записи файла ""%1"".
						             |Причина: %2'"),
						  ПолноеИмяФайла,
						  ?(инфоОшибка.Причина = Неопределено, "Неопределено", инфоОшибка.Причина.Описание) );
						
						Результат = Вопрос(стрТекст, РежимДиалогаВопрос.ПрерватьПовторитьПропустить, , КодВозвратаДиалога.Повторить);
						Если Результат = КодВозвратаДиалога.Прервать Тогда
							
							// Просто выйдем с ошибкой
							Возврат Ложь;
						ИначеЕсли Результат = КодВозвратаДиалога.Пропустить Тогда
							
							// Пропустим этот файл и пойдем дальше
							Прервать;
						Иначе
							
							// Попробуем повторить создание папки
							Продолжить;
						КонецЕсли;
					КонецПопытки;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
		Возврат Истина;
		
	#КонецЕсли
КонецФункции // ОбойтиДеревоФайлов()

&НаКлиенте
Процедура ПапкаДляЭкспортаОткрытие(Элемент, СтандартнаяОбработка)
	#Если НЕ ВебКлиент Тогда
	
		// Здесь откроем папку для просмотра - вдруг что-то сделать понадобиться
		СтандартнаяОбработка = Ложь;
		Если Не ПустаяСтрока(ПапкаДляЭкспорта) Тогда
			Файл = Новый Файл(ПапкаДляЭкспорта);
			Если Файл.Существует() Тогда
				ЗапуститьПриложение(ПапкаДляЭкспорта);
			Иначе
				Предупреждение(НСтр("ru = 'Невозможно открыть папку выгрузки. Возможно, папка еще не создана.'"));
			КонецЕсли;
		КонецЕсли;
	
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		ПоказатьПредупреждение(Неопределено,НСтр("ru = 'В Веб-клиенте экспорт каталогов не поддерживается.'"));
		Отказ = Истина;
		Возврат;
	#КонецЕсли
	
	// Установка в качестве папки выгрузки "Мои Документы"
	// папку, используемую для выгрузки последний раз.
	ПапкаДляЭкспорта = ФайловыеФункцииСлужебныйКлиент.КаталогВыгрузки();
	
	ПапкаДляЭкспортаПолная =
		  ПапкаДляЭкспорта
		+ Строка(ЧтоСохраняем)
		+ ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьСлеш(
			ОбщегоНазначенияКлиентПовтИсп.ТипПлатформыКлиента());
	
КонецПроцедуры
