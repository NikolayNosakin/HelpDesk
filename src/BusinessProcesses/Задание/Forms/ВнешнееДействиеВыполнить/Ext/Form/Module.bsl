﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Для нового объекта выполняем код инициализации формы в ПриСозданииНаСервере.
	// Для существующего - в ПриЧтенииНаСервере.
	Если Объект.Ссылка.Пустая() Тогда
		ИнициализацияФормы();
	КонецЕсли;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Если (Объект.Автор.Пустая() ИЛИ Не ПользовательЕстьВБазе(Объект.Автор)) И Не ПустаяСтрока(Объект.АвторСтрокой) Тогда
		Элементы.Автор.Видимость = Ложь;
		Элементы.АвторСтрокой.Видимость = Истина;
	Иначе
		Элементы.Автор.Видимость = Истина;
		Элементы.АвторСтрокой.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.Предмет = Неопределено Или Объект.Предмет.Пустая() Тогда
		Элементы.Предмет.Видимость = Ложь;
	Иначе
		Элементы.Предмет.Видимость = Истина;
	КонецЕсли;	
	
	ДанныеХранилища = Объект.БизнесПроцесс.СодержаниеПредмета.Получить();
	Если ДанныеХранилища <> Неопределено Тогда
		Если ТипЗнч(ДанныеХранилища) = Тип("Строка") Тогда
			ПредметHTML = ДанныеХранилища;
			Элементы.ПредметHTML.Видимость = Истина;
			Элементы.ПредметMXL.Видимость = Ложь;
		ИначеЕсли ТипЗнч(ДанныеХранилища) = Тип("ТабличныйДокумент") Тогда	
			ПредметMXL = ДанныеХранилища;
			Элементы.ПредметHTML.Видимость = Ложь;
			Элементы.ПредметMXL.Видимость = Истина;
		КонецЕсли;	
	КонецЕсли;	
	
	Файлы.Параметры.УстановитьЗначениеПараметра("ВладелецФайла", Объект.БизнесПроцесс.Ссылка);
	Файлы.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь", Пользователи.ТекущийПользователь());
	РаботаСФайламиВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(Файлы);
	
	Если Не Объект.Исполнитель.Пустая() Тогда
		ИсполнительСтрокой = Строка(Объект.Исполнитель);
	ИначеЕсли Не Объект.РольИсполнителя.Пустая() Тогда
		ИсполнительСтрокой = Строка(Объект.РольИсполнителя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ВыполнитьЗадачу = Ложь;
	Если НЕ (ПараметрыЗаписи.Свойство("ВыполнитьЗадачу", ВыполнитьЗадачу) И ВыполнитьЗадачу) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗаданиеВыполнено И НЕ ЗначениеЗаполнено(ТекущийОбъект.РезультатВыполнения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите причину, по которой задача отклоняется.'"),,
			"Объект.РезультатВыполнения",,
			Отказ);
		Возврат;
	КонецЕсли;
	
	// запись объекта бизнес-процесса
	ЗаписатьРеквизитыБизнесПроцесса(ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИмпортФайловЗавершен" Тогда
		Элементы.Файлы.Обновить();
		
		Если Параметр <> Неопределено Тогда
			Элементы.Файлы.ТекущаяСтрока = Параметр;
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" Тогда
		Элементы.Файлы.Обновить();
		
		Если ТипЗнч(Параметр) = Тип("Структура") Тогда
			Элементы.Файлы.ТекущаяСтрока = Параметр.Файл;
		КонецЕсли;	
		
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		
		ВладелецФайла = Неопределено;
		
		Если ТипЗнч(Параметр) = Тип("Структура") Тогда
			ВладелецФайла = Параметр.Владелец;
		Иначе	
			ВладелецФайла = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Параметр, "ВладелецФайла");
		КонецЕсли;	
		
		Если ВладелецФайла = Объект.Ссылка Тогда
			
			Элементы.Файлы.Обновить();
			ОбновитьДоступностьКомандСпискаФайлов();
			
		КонецЕсли;	
		
 	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИнициализацияФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗначениеПараметра = Файлы.Параметры.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВладелецФайла"));
	Если Не ЗначениеЗаполнено(ЗначениеПараметра.Значение) Тогда 
		Файлы.Параметры.УстановитьЗначениеПараметра("ВладелецФайла", Объект.Ссылка);
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СрокНачалаИсполненияПриИзменении(Элемент)
	
	Если Объект.ДатаНачала = НачалоДня(Объект.ДатаНачала) Тогда
		Объект.ДатаНачала = КонецДня(Объект.ДатаНачала);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИсполненияПриИзменении(Элемент)
	
	Если Объект.ДатаИсполнения = НачалоДня(Объект.ДатаИсполнения) Тогда
		Объект.ДатаИсполнения = КонецДня(Объект.ДатаИсполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	Если ТипЗнч(Объект.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		БизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Объект.Предмет);
	Иначе	
		ОткрытьЗначение(Объект.Предмет);
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Файлы

&НаКлиенте
Процедура СписокФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КакОткрывать = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами().ДействиеПоДвойномуЩелчкуМыши;
	Если КакОткрывать = "ОткрыватьКарточку" Тогда
		ПоказатьЗначение(Неопределено, ВыбраннаяСтрока);
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		ВыбраннаяСтрока, Неопределено, ЭтотОбъект.УникальныйИдентификатор);
	
	ВыбранныйРежим = ВыбратьРежимИРедактироватьФайл(ДанныеФайла);
	Если ВыбранныйРежим = "Редактировать" Тогда
		ОбновитьДоступностьКомандСпискаФайлов();
		Возврат;
	ИначеЕсли ВыбранныйРежим = "Отмена" Тогда
		Возврат;
	КонецЕсли;	
	
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла); 
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПриАктивизацииСтроки(Элемент)
	ОбновитьДоступностьКомандСпискаФайлов();
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	Если Объект.Ссылка.Пустая() Тогда 
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			"Создание:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ВладелецФайла = Объект.БизнесПроцесс;
	ФайлОснование = Элементы.Файлы.ТекущаяСтрока;
	
	Если Не Копирование Тогда
		Попытка
			РежимСоздания = 1;
			РаботаСФайламиКлиент.СозданиеНовогоФайла(ВладелецФайла, ЭтотОбъект, РежимСоздания, Истина);
		Исключение
			ПоказатьПредупреждение(Новый ОписаниеОповещения("ФайлыПередНачаломДобавленияЗавершение", ЭтотОбъект, Новый Структура("ВладелецФайла, ФайлОснование", ВладелецФайла, ФайлОснование)), ФайловыеФункцииСлужебныйКлиентСервер.ОшибкаСозданияНовогоФайла(
				ИнформацияОбОшибке()));
            Возврат;
		КонецПопытки;
	Иначе
		РаботаСФайламиКлиент.СкопироватьФайл(ВладелецФайла, ФайлОснование);
	КонецЕсли;
	ФайлыПередНачаломДобавленияФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПередНачаломДобавленияЗавершение(ДополнительныеПараметры) Экспорт
	
	ВладелецФайла = ДополнительныеПараметры.ВладелецФайла;
	ФайлОснование = ДополнительныеПараметры.ФайлОснование;
	
	
	ФайлыПередНачаломДобавленияФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ФайлыПередНачаломДобавленияФрагмент()
	
	Элементы.Файлы.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ФайлыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ФайлыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Файлы.ТолькоПросмотр Тогда 
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда 
		Если Не Записать() Тогда 
			Возврат;
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			"Создание:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ВладелецФайлаСписка = Объект.БизнесПроцесс;
	НеОткрыватьКарточкуПослеСозданияИзФайла = Истина;	
	РаботаСФайламиКлиент.ОбработкаПеретаскиванияВЛинейныйСписок(ПараметрыПеретаскивания, ВладелецФайлаСписка, ЭтотОбъект, НеОткрыватьКарточкуПослеСозданияИзФайла);
	Элементы.Файлы.Обновить();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики команд, связанных с таблицей формы Файлы

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(Элементы.Файлы.ТекущаяСтрока, Неопределено, ЭтотОбъект.УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляСохранения(Элементы.Файлы.ТекущаяСтрока, Неопределено, ЭтотОбъект.УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИРабочийКаталог(Элементы.Файлы.ТекущаяСтрока);
	КомандыРаботыСФайламиКлиент.ОбновитьИзФайлаНаДиске(ДанныеФайла, ЭтотОбъект.УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	Если Объект.Ссылка.Пустая()
		И Элементы.ФайлыДобавленные.ТекущаяСтрока <> Неопределено Тогда
		Если ЭтоАдресВременногоХранилища(Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть) Тогда 
			ТекущийФайлВСпискеДобавленных = ПолучитьИзВременногоХранилища(Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть).Ссылка;
			Записать();
		Иначе
			НачатьЗапускПриложения(Неопределено, Элементы.ФайлыДобавленные.ТекущиеДанные.ПолныйПуть);
		КонецЕсли;	
	Иначе
		
		Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
			Возврат;
		КонецЕсли;
			
		КомандыРаботыСФайламиКлиент.Редактировать(Элементы.Файлы.ТекущаяСтрока);
		
		ОбновитьДоступностьКомандСпискаФайлов();
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КомандыРаботыСФайламиКлиент.ЗакончитьРедактирование(
		Элементы.Файлы.ТекущаяСтрока,
		ЭтотОбъект.УникальныйИдентификатор,
		Элементы.Файлы.ТекущиеДанные.ХранитьВерсии,
		Элементы.Файлы.ТекущиеДанные.РедактируетТекущийПользователь,
		Элементы.Файлы.ТекущиеДанные.Редактирует);
		
	ОбновитьДоступностьКомандСпискаФайлов();
		
КонецПроцедуры

&НаКлиенте
Процедура Занять(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;

	КомандыРаботыСФайламиКлиент.Занять(Элементы.Файлы.ТекущаяСтрока);
	
	ОбновитьДоступностьКомандСпискаФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КомандыРаботыСФайламиКлиент.ОсвободитьФайл(
		Элементы.Файлы.ТекущаяСтрока,
		Элементы.Файлы.ТекущиеДанные.ХранитьВерсии,
		Элементы.Файлы.ТекущиеДанные.РедактируетТекущийПользователь,
		Элементы.Файлы.ТекущиеДанные.Редактирует);
		
	ОбновитьДоступностьКомандСпискаФайлов();
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если Элементы.Файлы.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КомандыРаботыСФайламиКлиент.ОпубликоватьФайл(
		Элементы.Файлы.ТекущаяСтрока, 
		ЭтотОбъект.УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортФайлов(Команда)
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	РасширениеПодключено = Неопределено;

	НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения("ИмпортФайловЗавершение", ЭтотОбъект));		
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортФайловЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	
	РасширениеПодключено = Подключено;
	
	Если НЕ РасширениеПодключено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Для импорта файлов необходимо установить расширение работы с файлами.'"));
	Иначе	
		
		Если Объект.Ссылка.Пустая() Тогда 
			Если Не Записать() Тогда 
				Возврат;
			КонецЕсли;
			
			ПоказатьОповещениеПользователя(
			"Создание:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		КонецЕсли;
		
		ВыполнитьИмпортФайлов(Объект.БизнесПроцесс);
		
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполненоВыполнить(Команда)
	
	ЗаданиеВыполнено = Истина;
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Отменено(Команда)
	
	ЗаданиеВыполнено = Ложь;
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Дополнительно(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПринятьЗадачуКИсполнению(ЭтотОбъект, ТекущийПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ОтменитьПринятиеЗадачиКИсполнению(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ИнициализацияФормы()
	
	НачальныйПризнакВыполнения = Объект.Выполнена;
	ПрочитатьРеквизитыБизнесПроцесса();	
	УстановитьСостояниеЭлементов();
	            
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.СрокИсполнения);
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.Дата);
	
	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(ЭтотОбъект, Объект, 
		Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);
	Элементы.ОписаниеРезультата.ТолькоПросмотр = Объект.Выполнена;
	
КонецПроцедуры	

&НаСервере
Процедура ПрочитатьРеквизитыБизнесПроцесса()
	
	ЗадачаОбъект = РеквизитФормыВЗначение("Объект");
	
	УстановитьПривилегированныйРежим(Истина);
	ЗаданиеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗаданиеВыполнено = ЗаданиеОбъект.Выполнено;
	ЗаданиеРезультатВыполнения = ЗаданиеОбъект.РезультатВыполнения;
	ЗаданиеСодержание = ЗаданиеОбъект.Содержание;
	
КонецПроцедуры	

&НаСервере
Процедура ЗаписатьРеквизитыБизнесПроцесса(ЗадачаОбъект)
	
	УстановитьПривилегированныйРежим(Истина);
	ЗаданиеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ЗаданиеОбъект.Ссылка);
	ЗаданиеОбъект.Выполнено = ЗаданиеВыполнено;
	ЗаданиеОбъект.Записать();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеЭлементов()
	
	БизнесПроцессы.Задание.УстановитьСостояниеЭлементовФормыЗадачи(ЭтотОбъект);
	
КонецПроцедуры	

&НаКлиенте
Процедура ОбновитьДоступностьКомандСпискаФайлов()
	УстановитьДоступностьКоманд(Элементы.Файлы.ТекущиеДанные);
КонецПроцедуры	

// Выбрать режим открытия файла и начать редактирование
&НаКлиенте
Функция ВыбратьРежимИРедактироватьФайл(ДанныеФайла) 
	
	// Если уже занят для редактирования, то не спрашивать - сразу открывать
	Если ДанныеФайла.Редактирует.Пустая() Тогда
		
		СпрашиватьРежимРедактированияПриОткрытииФайла = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами().СпрашиватьРежимРедактированияПриОткрытииФайла;
		Если СпрашиватьРежимРедактированияПриОткрытииФайла = Истина Тогда
			
			КакОткрывать = Неопределено;
			
			Результат = ОткрытьФормуМодально("Справочник.Файлы.Форма.ФормаВыбораРежимаОткрытия");
			Если ТипЗнч(Результат) <> Тип("Структура") Тогда
				Возврат "Отмена";
			КонецЕсли;
			
			БольшеНеСпрашивать = Результат.БольшеНеСпрашивать;
			Если БольшеНеСпрашивать = Истина Тогда
				ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиОткрытияФайлов", "СпрашиватьРежимРедактированияПриОткрытииФайла", Ложь);
				ОбновитьПовторноИспользуемыеЗначения();
			КонецЕсли;
			
			КакОткрывать = Результат.КакОткрывать;
			
			Если КакОткрывать = 1 Тогда
				РаботаСФайламиКлиент.РедактироватьФайл(ДанныеФайла);
				ОповеститьОбИзменении(ДанныеФайла.Ссылка);
				Возврат "Редактировать";
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат "Открыть";
	
КонецФункции	

&НаКлиенте
Процедура УстановитьДоступностьКоманды(Команда, Доступность)
	Команда.Доступность = Доступность;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено Тогда 
		
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОткрытьФайл, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюРедактировать, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗакончитьРедактирование, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗанять, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьИзменения, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьКак, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОсвободить, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОбновитьИзФайлаНаДиске, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюПодписатьФайл, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюДобавитьЭЦПИзФайла, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьВместеСЭЦП, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗашифровать, Ложь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюРасшифровать, Ложь);
		
	Иначе	
		
		РедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;
		Редактирует = ТекущиеДанные.Редактирует;
		ПодписанЭЦП 	= ТекущиеДанные.ПодписанЭЦП;
		Зашифрован 	= ТекущиеДанные.Зашифрован;
		
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОткрытьФайл, Истина);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюРедактировать, НЕ ТекущиеДанные.ПодписанЭЦП);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗакончитьРедактирование, РедактируетТекущийПользователь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗанять, Редактирует.Пустая());
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьИзменения, РедактируетТекущийПользователь);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьКак, Истина);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОсвободить, Не Редактирует.Пустая());
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюОбновитьИзФайлаНаДиске, Истина);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюПодписатьФайл, Редактирует.Пустая() И НЕ Зашифрован);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюДобавитьЭЦПИзФайла, Редактирует.Пустая() И НЕ Зашифрован);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюСохранитьВместеСЭЦП, ПодписанЭЦП);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюЗашифровать, Редактирует.Пустая() И НЕ Зашифрован);
		УстановитьДоступностьКоманды(Элементы.ФайлыКонтекстноеМенюРасшифровать, Зашифрован);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Выполнить импорт файлов
Процедура ВыполнитьИмпортФайлов(ВладелецИмпортированныхФайлов)
	
	// заранее выбираем файлы (до открытия диалога импорта)
	Режим = РежимДиалогаВыбораФайла.Открытие;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Истина;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файлы'");
	ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения("ВыполнитьИмпортФайловЗавершение", ЭтотОбъект, Новый Структура("ВладелецИмпортированныхФайлов, ДиалогОткрытияФайла", ВладелецИмпортированныхФайлов, ДиалогОткрытияФайла)));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьИмпортФайловЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	ВладелецИмпортированныхФайлов = ДополнительныеПараметры.ВладелецИмпортированныхФайлов;
	ДиалогОткрытияФайла = ДополнительныеПараметры.ДиалогОткрытияФайла;
	
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		МассивИменФайлов = Новый Массив;
		
		МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
		Для Каждого ИмяФайла Из МассивФайлов Цикл
			МассивИменФайлов.Добавить(ИмяФайла);
		КонецЦикла;
		
		ПараметрыИмпорта = Новый Структура("ПапкаДляДобавления, МассивИменФайлов", 
		ВладелецИмпортированныхФайлов, МассивИменФайлов);
		ОткрытьФорму("Справочник.Файлы.Форма.ФормаИмпортаФайлов", ПараметрыИмпорта);
	КонецЕсли;

КонецПроцедуры	

&НаСервере
Функция ПользовательЕстьВБазе(Автор)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Пользователи.Ссылка
	               |ИЗ
	               |	Справочник.Пользователи КАК Пользователи
	               |ГДЕ
	               |	Пользователи.Ссылка = &Автор";
				   
	Запрос.УстановитьПараметр("Автор", Автор);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции 	