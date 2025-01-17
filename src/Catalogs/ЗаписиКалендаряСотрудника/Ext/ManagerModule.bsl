﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ОбъектПоИдентификатору(Идентификатор, Календарь) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаписиКалендаряСотрудника.Ссылка
	|ИЗ
	|	Справочник.ЗаписиКалендаряСотрудника КАК ЗаписиКалендаряСотрудника
	|ГДЕ
	|	ЗаписиКалендаряСотрудника.Ключ = &Ключ
	|	И ЗаписиКалендаряСотрудника.Календарь = &Календарь");
	Запрос.УстановитьПараметр("Ключ", "");//ОбменСGoogle.КлючИзИдентификатора(Идентификатор, ТипЗнч(Справочники.ЗаписиКалендаряСотрудника)));
	Запрос.УстановитьПараметр("Календарь", Календарь);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Результат = Справочники.ЗаписиКалендаряСотрудника.СоздатьЭлемент();
		Результат.УстановитьНовыйКод();
		Возврат Результат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка.ПолучитьОбъект();
	
КонецФункции

Функция СохранитьИзмененияЗаписейКалендарей(ОбрабатываемыеЭлементы) Экспорт
	
	НезависимыеЗаписи = Новый Массив;
	ПодчиненныеИсточнику = Новый Соответствие;
	
	Для Каждого ОбрабатываемыйЭлемент Из ОбрабатываемыеЭлементы Цикл
		Если ЗначениеЗаполнено(ОбрабатываемыйЭлемент.Источник) Тогда
			ЗаписиПоИсточнику = ПодчиненныеИсточнику.Получить(ОбрабатываемыйЭлемент.Источник);
			Если ЗаписиПоИсточнику = Неопределено Тогда
				ЗаписиПоИсточнику = Новый Массив;
				ЗаписиПоИсточнику.Добавить(ОбрабатываемыйЭлемент);
				ПодчиненныеИсточнику.Вставить(ОбрабатываемыйЭлемент.Источник, ЗаписиПоИсточнику);
			Иначе
				ЗаписиПоИсточнику.Добавить(ОбрабатываемыйЭлемент);
			КонецЕсли;
		Иначе
			НезависимыеЗаписи.Добавить(ОбрабатываемыйЭлемент);
		КонецЕсли;
	КонецЦикла;
	
	НачатьТранзакцию();
	
	Попытка
	
		Для Каждого КлючИЗначение Из ПодчиненныеИсточнику Цикл
			
			ИсточникОбъект = КлючИЗначение.Ключ.ПолучитьОбъект();
			
			Если ОбрабатываемыйЭлемент.Свойство("ПометкаУдаления") Тогда
				//ИсточникОбъект.УстановитьПометкуУдаления(ОбрабатываемыйЭлемент.ПометкаУдаления);
				
				Менеджерзаписи = РегистрыСведений.ПланированиеЗаявок.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Заявка = ИсточникОбъект.Ссылка;
				МенеджерЗаписи.ЗаписьКалендаря = ОбрабатываемыйЭлемент.ЗаписьКалендаря;
				МенеджерЗаписи.Прочитать();
				
				Если МенеджерЗаписи.Выбран() Тогда
					МенеджерЗаписи.Удалить();
				КонецЕслИ;

				ЗаписьОбъект = ОбрабатываемыйЭлемент.ЗаписьКалендаря.ПолучитьОбъект();
		        ЗаписьОбъект.УстановитьПометкуУдаления(ОбрабатываемыйЭлемент.ПометкаУдаления);
				
				Продолжить;
			КонецЕсли;
						
			Если ОбрабатываемыйЭлемент.Свойство("Исполнитель") И ИсточникОбъект.КалендарьСотрудника.ВладелецКалендаря <>  ОбрабатываемыйЭлемент.Исполнитель Тогда
				ПользовательКалендаря = ОбрабатываемыйЭлемент.Пользователь;
				Если НЕ ЗначениеЗаполнено(ПользовательКалендаря) Тогда
					Сообщить("Для сотрудника "+ОбрабатываемыйЭлемент.исполнитель+" не удалось определить пользователя!");
					ОтменитьТранзакцию();
					Возврат Ложь;
				КонецЕсли;	
				
				КалендарьДляПереданныхЗадач =
				ХранилищеОбщихНастроек.Загрузить(
				"НастройкиРаботыСКалендарем",
				"КалендарьДляПереданныхЗадач",ПользовательКалендаря);
				
				Если НЕ ЗначениеЗаполнено(КалендарьДляПереданныхЗадач) Тогда 
					Сообщить("Для пользователя "+ОбрабатываемыйЭлемент.исполнитель+" не указан календарь для переданных задач!");
					ОтменитьТранзакцию();
					Возврат Ложь;
				КонецЕсли;
				
				ИсточникОбъект.КалендарьСотрудника = КалендарьДляПереданныхЗадач;
			КонецЕсли;
			
			Если ОбрабатываемыйЭлемент.Свойство("Календарь") И Не ЗначениеЗаполнено(ИсточникОбъект.КалендарьСотрудника) Тогда
				ИсточникОбъект.КалендарьСотрудника = ОбрабатываемыйЭлемент.Календарь;
			КонецЕсли;
			
			ИсточникОбъект.ОбновитьИсточникПриИзмененииЗаписиКалендаря(КлючИЗначение.Значение);

			ИсточникОбъект.Записать();
			
		КонецЦикла;
		
		Для Каждого ОбрабатываемыйЭлемент Из НезависимыеЗаписи Цикл
			
			ЗаписьОбъект = ОбрабатываемыйЭлемент.ЗаписьКалендаря.ПолучитьОбъект();
			
			Если ОбрабатываемыйЭлемент.Свойство("ПометкаУдаления") Тогда
				ЗаписьОбъект.УстановитьПометкуУдаления(ОбрабатываемыйЭлемент.ПометкаУдаления);				
				Продолжить;
			КонецЕсли;
			
			Если ОбрабатываемыйЭлемент.Свойство("Исполнитель") И ЗаписьОбъект.Календарь.ВладелецКалендаря <>  ОбрабатываемыйЭлемент.исполнитель Тогда
				ПользовательКалендаря = ОбрабатываемыйЭлемент.Пользователь;
				Если НЕ ЗначениеЗаполнено(ПользовательКалендаря) Тогда
					Сообщить("Для сотрудника "+ОбрабатываемыйЭлемент.исполнитель+" не удалось определить пользователя!");
					ОтменитьТранзакцию();
					Возврат Ложь;
				КонецЕсли;	
				
				КалендарьДляПереданныхЗадач =
				ХранилищеОбщихНастроек.Загрузить(
				"НастройкиРаботыСКалендарем",
				"КалендарьДляПереданныхЗадач",ПользовательКалендаря);
						
				Если НЕ ЗначениеЗаполнено(КалендарьДляПереданныхЗадач) Тогда 
					Сообщить("Для пользователя "+ОбрабатываемыйЭлемент.исполнитель+" не указан календарь для переданных задач!");
					ОтменитьТранзакцию();
					Возврат Ложь;
				КонецЕсли;
				
				ЗаписьОбъект.Календарь = КалендарьДляПереданныхЗадач;
			КонецЕсли;
			
			ЗаписьОбъект.Начало		= ОбрабатываемыйЭлемент.Начало;
			ЗаписьОбъект.Окончание	= ОбрабатываемыйЭлемент.Конец;
			ЗаписьОбъект.Записать();
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		Успешно = Истина;
		
	Исключение
		
		ОтменитьТранзакцию();
		Успешно = Ложь;
		ВызватьИсключение СтрШаблон(НСтр("ru='Не удалось сохранить изменения в календаре по причине: %1';uk='Не вдалося зберегти зміни в календарі через: %1'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	Возврат Успешно;
	
КонецФункции

// Функция возвращает таблицу описаний возможных расширенных вводов записи календаря
// 
// Возвращаемое значение:
//  ТаблицаЗначений - таблица с колонками
//		ИмяФормы		- Строка - полный путь к форме для использования в ОтрытьФорму()
//		ПараметрыФормы	- Структура - параметры открываемой формы
//		Представление	- Строка - пользовательское представление расширенного ввода
//
Функция ОписаниеРасширенногоВводаЗаписей() Экспорт
	
	ТаблицаОписания = Новый ТаблицаЗначений;
	ТаблицаОписания.Колонки.Добавить("ИмяФормы",		Новый ОписаниеТипов("Строка"));
	ТаблицаОписания.Колонки.Добавить("ПараметрыФормы",	Новый ОписаниеТипов("Структура"));
	ТаблицаОписания.Колонки.Добавить("Представление",	Новый ОписаниеТипов("Строка"));
	
	ТипыЗаписей = Метаданные.ОпределяемыеТипы.ИсточникЗаписейКалендаря.Тип.Типы();
	
	Для Каждого ТипЗаписиКалендаря Из ТипыЗаписей Цикл
		
		МетаданныеТипа = Метаданные.НайтиПоТипу(ТипЗаписиКалендаря);
		МенеджерТипа = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеТипа.ПолноеИмя());
		
		МенеджерТипа.ПриЗаполненииРасширенногоВводаЗаписиКалендаря(ТаблицаОписания);
		
	КонецЦикла;
	
	ТаблицаОписания.Сортировать("Представление УБЫВ");
	
	Возврат ТаблицаОписания;
	
КонецФункции

#КонецОбласти

#КонецЕсли