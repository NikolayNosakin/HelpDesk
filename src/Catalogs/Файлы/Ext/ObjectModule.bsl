﻿


// Обработка события ПередЗаписью
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("КонвертацияФайлов") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВладелецФайла) Тогда
		
		Если ОбновлениеИнформационнойБазы.ВыполняетсяОбновлениеИнформационнойБазы() Тогда
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы.Запись файла'"), 
				УровеньЖурналаРегистрации.Ошибка, , Ссылка,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В файле ""%1"" не заполнен ВладелецФайла'"),
				Строка(Ссылка)));
				
		Иначе	
				
			ВызватьИсключение НСтр("ru = 'Нельзя записать файл, если не указан владелец файла.'");
			
		КонецЕсли;	
		
	КонецЕсли;
	
	Если Не ЭтоНовый() Тогда
		
		ЕстьПометкаУдаленияВИБ = ПометкаУдаленияВИБ();
		УстановленаПометкаУдаления = ПометкаУдаления И Не ЕстьПометкаУдаленияВИБ;
		ИзмененаПометкаУдаления = (ПометкаУдаления <> ЕстьПометкаУдаленияВИБ);
				
		Если Не ТекущаяВерсия.Пустая() Тогда
			
			РеквизитыТекущейВерсии = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ТекущаяВерсия, 
				"ПолноеНаименование");
			
			// Проверим равенство имени файла и его текущей версии
			// Если имена отличаются - имя у версии должно стать как у карточки с файлом
			Если РеквизитыТекущейВерсии.ПолноеНаименование <> ПолноеНаименование Тогда
				Объект = ТекущаяВерсия.ПолучитьОбъект();
				Если Объект <> Неопределено И Объект.Ссылка <> Неопределено Тогда
					ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка);
					УстановитьПривилегированныйРежим(Истина);
					Объект.ПолноеНаименование = ПолноеНаименование;
					Объект.ДополнительныеСвойства.Вставить("ПереименованиеФайла", Истина); // чтобы не сработала подписка СкопироватьРеквизитыВерсииФайловВФайл
					Объект.Записать();
					УстановитьПривилегированныйРежим(Ложь);
				КонецЕсли;	
			КонецЕсли;
			
		КонецЕсли;
		
		Если ИзмененаПометкаУдаления Тогда
			
			// Проверка права "Пометка на удаление".
			Если НЕ РаботаСФайламиПереопределяемый.ПометкаУдаленияРазрешена(ВладелецФайла) Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				                     НСтр("ru = 'У вас нет права ""Пометка на удаление"" файла ""%1"".'"),
				                     Строка(Ссылка));
			КонецЕсли;
			
			// Попытка установить пометку удаления
			Если УстановленаПометкаУдаления И Не Редактирует.Пустая() Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				                    НСтр("ru = 'Нельзя удалить файл ""%1"", т.к. он занят для редактирования пользователем ""%2"".'"),
				                    ПолноеНаименование,
				                    Строка(Редактирует) );
			КонецЕсли;
			
		КонецЕсли;
		
		НаименованиеВИБ = НаименованиеВИБ();
		Если ПолноеНаименование <> НаименованиеВИБ Тогда 
			Если Не Редактирует.Пустая() Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				                    НСтр("ru = 'Нельзя переименовать файл ""%1"", т.к. он занят для редактирования пользователем ""%2"".'"),
				                    НаименованиеВИБ,
				                    Строка(Редактирует) );
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	
	Наименование = СокрЛП(ПолноеНаименование);
КонецПроцедуры

// Возвращает текущее значение пометки удаления в информационной базе
Функция ПометкаУдаленияВИБ()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Файлы.ПометкаУдаления
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|ГДЕ
		|	Файлы.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Результат = Запрос.Выполнить();

	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ПометкаУдаления;
	КонецЕсли;	
	
	Возврат Неопределено;
КонецФункции

// Возвращает текущее значение наименования в информационной базе
Функция НаименованиеВИБ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Файлы.ПолноеНаименование
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|ГДЕ
	|	Файлы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ПолноеНаименование;
	КонецЕсли;
	
	Возврат Неопределено;	
	
КонецФункции

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда
		ДатаСоздания = ТекущаяДатаСеанса();
		ХранитьВерсии = Истина;
		ИндексКартинки = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Неопределено);
		
		Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

