﻿Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда 
		Руководитель = Пользователи.ТекущийПользователь();
		ГрафикРаботы = Константы.ОсновнойГрафикРаботы.Получить();
		Состояние = Перечисления.СостоянияПроектов.Инициирован;
		ЕдиницаТрудозатратЗадач = Константы.ОсновнаяЕдиницаТрудозатрат.Получить();
		ЕдиницаДлительностиЗадач = Константы.ОсновнаяЕдиницаДлительности.Получить();
		СписыватьЗатратыНаПроект = Истина;
		СпособПланирования = Перечисления.СпособыПланированияПроекта.ОтДатыНачалаПроекта;
		
		Если Не ЗначениеЗаполнено(ВидПроекта) Тогда 
			ВидПроекта = РаботаСПроектами.ПолучитьВидПроектаПоУмолчанию();
		КонецЕсли;	
		
		Если ПолучитьФункциональнуюОпцию("ВестиУчетПоОрганизациям") Тогда
			Организация = РаботаСОрганизациями.ПолучитьОрганизациюПоУмолчанию();
		КонецЕсли;
		
	КонецЕсли;	
	
	Если ВстроеннаяПочтаКлиентСервер.ЭтоПисьмо(ДанныеЗаполнения) Тогда
		Наименование = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ДанныеЗаполнения, "Тема");
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка
		И ЗначениеЗаполнено(ОбменДанными.Отправитель) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		ДополнительныеСвойства.Вставить("ЭтоНовый", Истина);
	КонецЕсли;
	
	ПредыдущаяПометкаУдаления = Ложь;
	Если Не Ссылка.Пустая() Тогда
		ПредыдущаяПометкаУдаления = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ПометкаУдаления");
	КонецЕсли;
	
	Если ПометкаУдаления <> ПредыдущаяПометкаУдаления Тогда 
		Если ПометкаУдаления Тогда
			ДополнительныеСвойства.Вставить("НужноПометитьНаУдалениеБизнесСобытия", Истина);
		КонецЕсли;
	КонецЕсли;
	
	ПредыдущийТекущийПланНачало = ТекущийПланНачало;
	ПредыдущийТекущийПланОкончание = ТекущийПланОкончание;
	ПредыдущийСпособПланирования = СпособПланирования;
	
	Если Не Ссылка.Пустая() Тогда
		ПредыдущийТекущийПланНачало = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ТекущийПланНачало");
		ПредыдущийТекущийПланОкончание = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ТекущийПланОкончание");
		ПредыдущийСпособПланирования = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "СпособПланирования");
	КонецЕсли;
	
	Если (ПредыдущийТекущийПланНачало <> ТекущийПланНачало Или ПредыдущийСпособПланирования <> СпособПланирования) 
		И СпособПланирования = Перечисления.СпособыПланированияПроекта.ОтДатыНачалаПроекта Тогда
		ДополнительныеСвойства.Вставить("НужноОбновитьНачалоПроектныхЗадач", Истина);
	КонецЕсли;
	
	Если (ПредыдущийТекущийПланОкончание <> ТекущийПланОкончание Или ПредыдущийСпособПланирования <> СпособПланирования)
		И СпособПланирования = Перечисления.СпособыПланированияПроекта.ОтДатыОкончанияПроекта Тогда
		ДополнительныеСвойства.Вставить("НужноОбновитьОкончаниеПроектныхЗадач", Истина);
	КонецЕсли;
	
	Если Не Ссылка.Пустая() Тогда 
		Если Руководитель <> ОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Руководитель") Тогда 
			ДополнительныеСвойства.Вставить("ИзменилсяРуководитель", Истина);
		КонецЕсли;	
	КонецЕсли;	
	
	// Обработка рабочей группы
	СсылкаОбъекта = Ссылка;
	// Установка ссылки нового
	Если Не ЗначениеЗаполнено(СсылкаОбъекта) Тогда
		
		СсылкаНового = Справочники.Проекты.ПолучитьСсылку();
		УстановитьСсылкуНового(СсылкаНового);
		СсылкаОбъекта = СсылкаНового;
		
	КонецЕсли;
			
	// Установка необходимости обновления прав доступа
	//ДополнительныеСвойства.Вставить("ДополнительныеПравообразующиеЗначенияИзменены");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка
		И ЗначениеЗаполнено(ОбменДанными.Отправитель) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("НужноОбновитьНачалоПроектныхЗадач") Тогда
		ОбновитьНачалоПроектныхЗадач();
	КонецЕсли;

	Если ДополнительныеСвойства.Свойство("НужноОбновитьОкончаниеПроектныхЗадач") Тогда
		ОбновитьОкончаниеПроектныхЗадач();
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ИзменилсяРуководитель") Тогда
		//ОбновитьПраваНаБизнесПроцессы();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьПраваНаБизнесПроцессы()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеБизнесПроцессов.БизнесПроцесс
	|ИЗ
	|	РегистрСведений.ДанныеБизнесПроцессов КАК ДанныеБизнесПроцессов
	|ГДЕ
	|	ДанныеБизнесПроцессов.Проект = &Проект";
	
	Запрос.УстановитьПараметр("Проект", Ссылка);
	
	МассивБизнесПроцессов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("БизнесПроцесс");
	
	// Обновление прав доступа
	//РегистрыСведений.ОчередьОбновленияДоступа.ОбновитьДоступ(
	//	Перечисления.ВидыЗаданийОбновленияДоступа.ОграниченияДоступаДляЗаданныхОбъектовДоступа,
	// 	Новый Структура("ОбъектыДоступа", МассивБизнесПроцессов));
	
КонецПроцедуры	

Процедура ОбновитьНачалоПроектныхЗадач()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПроектныеЗадачи.Ссылка,
		|	ПроектныеЗадачиПредшественники.Ссылка КАК СсылкаПредшественник
		|ИЗ
		|	Справочник.ПроектныеЗадачи КАК ПроектныеЗадачи
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПроектныеЗадачи.Предшественники КАК ПроектныеЗадачиПредшественники
		|		ПО ПроектныеЗадачи.Ссылка = ПроектныеЗадачиПредшественники.Ссылка
		|ГДЕ
		|	ПроектныеЗадачи.Владелец = &Владелец
		|	И ПроектныеЗадачиПредшественники.Ссылка ЕСТЬ NULL ";
		
	Запрос.УстановитьПараметр("Владелец", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗадачаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ЗадачаОбъект.ТекущийПланНачало = ТекущийПланНачало;
			ЗадачаОбъект.ТекущийПланОкончание = РаботаСПроектами.РассчитатьОкончаниеПериода(ЗадачаОбъект, 
				ЗадачаОбъект.ТекущийПланНачало, 
				ЗадачаОбъект.ТекущийПланДлительность, 
				ЗадачаОбъект.ТекущийПланЕдиницаДлительности);
			ЗадачаОбъект.Записать();
		КонецЦикла;
		РаботаСПроектами.РассчитатьПланВсегоПроекта(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьОкончаниеПроектныхЗадач()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПроектныеЗадачи.Ссылка,
		|	ПроектныеЗадачиПредшественники.Ссылка КАК СсылкаПредшественник
		|ИЗ
		|	Справочник.ПроектныеЗадачи КАК ПроектныеЗадачи
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПроектныеЗадачи.Предшественники КАК ПроектныеЗадачиПредшественники
		|		ПО ПроектныеЗадачи.Ссылка = ПроектныеЗадачиПредшественники.Предшественник
		|ГДЕ
		|	ПроектныеЗадачи.Владелец = &Владелец
		|	И ПроектныеЗадачиПредшественники.Ссылка ЕСТЬ NULL ";
		
	Запрос.УстановитьПараметр("Владелец", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗадачаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ЗадачаОбъект.ТекущийПланОкончание = ТекущийПланОкончание;
			ЗадачаОбъект.ТекущийПланНачало = РаботаСПроектами.РассчитатьНачалоПериода(ЗадачаОбъект, 
				ЗадачаОбъект.ТекущийПланНачало, 
				ЗадачаОбъект.ТекущийПланДлительность, 
				ЗадачаОбъект.ТекущийПланЕдиницаДлительности);
			ЗадачаОбъект.Записать();
		КонецЦикла;
		РаботаСПроектами.РассчитатьПланВсегоПроекта(Ссылка);
	КонецЕсли;
	
КонецПроцедуры


Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	КоличествоИсполнителей = ПроектнаяКоманда.Количество();
	Для Инд1 = 0 По КоличествоИсполнителей - 2 Цикл
		Строка1 = ПроектнаяКоманда[Инд1];
		
		Для Инд2 = Инд1+1 По КоличествоИсполнителей - 1 Цикл
			Строка2 = ПроектнаяКоманда[Инд2];
			
			ТекстСообщения = "";
			Если Строка1.Исполнитель = Строка2.Исполнитель И ТипЗнч(Строка1.Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда 
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Исполнитель ""%1"" указан дважды в списке проектной команды!'"),
					Строка(Строка1.Исполнитель));
				
			ИначеЕсли (Строка1.Исполнитель = Строка2.Исполнитель 
				И ТипЗнч(Строка1.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей")
				И Строка1.ОсновнойОбъектАдресации = Строка2.ОсновнойОбъектАдресации
				И Строка1.ДополнительныйОбъектАдресации = Строка2.ДополнительныйОбъектАдресации) Тогда 
				
				Если ЗначениеЗаполнено(Строка1.ОсновнойОбъектАдресации) 
					И ЗначениеЗаполнено(Строка1.ДополнительныйОбъектАдресации) Тогда 	
					
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Исполнитель ""%1 (%2, %3)"" указан дважды в списке проектной команды!'"),
						Строка(Строка1.Исполнитель),
						Строка(Строка1.ОсновнойОбъектАдресации),
						Строка(Строка1.ДополнительныйОбъектАдресации));
					
				ИначеЕсли ЗначениеЗаполнено(Строка1.ОсновнойОбъектАдресации) Тогда 
					
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Исполнитель ""%1 (%2)"" указан дважды в списке проектной команды!'"),
						Строка(Строка1.Исполнитель),
						Строка(Строка1.ОсновнойОбъектАдресации));
					
				Иначе
					
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Исполнитель ""%1"" указан дважды в списке проектной команды!'"), 
						Строка(Строка1.Исполнитель));
					
				КонецЕсли;	
				
			КонецЕсли;	
			
			Если ТекстСообщения <> "" Тогда 
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстСообщения,
					ЭтотОбъект,
					"ПроектнаяКоманда[" + Формат(Строка2.НомерСтроки-1, "ЧГ=0") + "].Исполнитель",, 
					Отказ);
			КонецЕсли;	
			
		КонецЦикла;	
	КонецЦикла;	
	
КонецПроцедуры

Функция ПоОбъектуВедетсяАвтоматическоеЗаполнениеРабочейГруппы()
	
	Если Не ЗначениеЗаполнено(ВидПроекта) Тогда
		Возврат Не ЗапретитьАвтоматическоеДобавлениеУчастниковРабочейГруппы;
	КонецЕсли;
	
	АвтоГруппа = ОбщегоНазначения.ПолучитьЗначениеРеквизита(ВидПроекта, "АвтоматическиВестиСоставУчастниковРабочейГруппы");
	
	Возврат АвтоГруппа И Не ЗапретитьАвтоматическоеДобавлениеУчастниковРабочейГруппы;
	
КонецФункции

