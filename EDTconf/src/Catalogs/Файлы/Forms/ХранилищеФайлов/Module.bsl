&НаКлиенте
Процедура ИмпортФайловВыполнить()
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	РасширениеПодключено = Неопределено;

	НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения("ИмпортФайловВыполнитьЗавершение1", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ИмпортФайловВыполнитьЗавершение1(Подключено, ДополнительныеПараметры) Экспорт
	
	РасширениеПодключено = Подключено;
	
	Если НЕ РасширениеПодключено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Для импорта файлов необходимо установить расширение работы с файлами.'"));
	Иначе	
		// заранее выбираем файлы (до открытия диалога импорта)
		Режим = РежимДиалогаВыбораФайла.Открытие;
		
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
		ДиалогОткрытияФайла.Фильтр = Фильтр;
		ДиалогОткрытияФайла.МножественныйВыбор = Истина;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файлы'");
		ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения("ИмпортФайловВыполнитьЗавершение", ЭтотОбъект, Новый Структура("ДиалогОткрытияФайла", ДиалогОткрытияФайла)));
	КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ИмпортФайловВыполнитьЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	ДиалогОткрытияФайла = ДополнительныеПараметры.ДиалогОткрытияФайла;
	
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		МассивИменФайлов = Новый Массив;
		
		МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
		Для Каждого ИмяФайла Из МассивФайлов Цикл
			МассивИменФайлов.Добавить(ИмяФайла);
		КонецЦикла;
		
		ПараметрыИмпорта = Новый Структура("ПапкаДляДобавления, МассивИменФайлов", Элементы.Папки.ТекущаяСтрока, МассивИменФайлов);
		ОткрытьФорму("Справочник.Файлы.Форма.ФормаИмпортаФайлов", ПараметрыИмпорта);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИмпортПапки(Команда)
	#Если ВебКлиент Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'В веб-клиенте импорт папок не поддерживается. Используйте команду ""Создать"" в списке файлов.'"));
	#Иначе	
	
		// заранее выбираем каталог на диске (до открытия диалога импорта)
		Каталог = "";
		Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
		
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
		ДиалогОткрытияФайла.Фильтр = Фильтр;
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите каталог'");
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			КаталогНаДиске = ДиалогОткрытияФайла.Каталог;
			ПараметрыИмпорта = Новый Структура("ПапкаДляДобавления, КаталогНаДиске", Элементы.Папки.ТекущаяСтрока, КаталогНаДиске);
			ОткрытьФорму("Справочник.Файлы.Форма.ФормаИмпортаПапки", ПараметрыИмпорта);
		КонецЕсли;
		
	#КонецЕсли
КонецПроцедуры

// Обработка события "Выбор" у "Список"
//
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	
	СтандартнаяОбработка = Ложь;
	
	КакОткрывать = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами().ДействиеПоДвойномуЩелчкуМыши;
	
	Если КакОткрывать = "ОткрыватьКарточку" Тогда
		ПоказатьЗначение(Неопределено, ВыбраннаяСтрока);
		Возврат;
	КонецЕсли;
	
	ИмяКаталога = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	Если ИмяКаталога = Неопределено ИЛИ ПустаяСтрока(ИмяКаталога) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(ВыбраннаяСтрока, 
		Неопределено, УникальныйИдентификатор, Неопределено, ПредыдущийАдресФайла);
	
	ВыбранныйРежим = РаботаСФайламиКлиент.ВыбратьРежимИРедактироватьФайл(ДанныеФайла, Истина);
	Если ВыбранныйРежим = "Редактировать" Тогда
		УстановитьДоступностьФайловыхКомманд();
		Возврат;
	ИначеЕсли ВыбранныйРежим = "Отмена" Тогда
		Возврат;
	КонецЕсли;	
	
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, УникальныйИдентификатор); 
	
КонецПроцедуры

// Обработка события "ПередНачаломДобавления" у "Список"
//
&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Элементы.Папки.ТекущаяСтрока = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	Если Элементы.Папки.ТекущаяСтрока.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	ВладелецФайла = Элементы.Папки.ТекущаяСтрока;
	ФайлОснование = Элементы.Список.ТекущаяСтрока;
	
	Отказ = Истина;
	
	Если Не Копирование Тогда
		
		Попытка
			РаботаСФайламиКлиент.СозданиеНовогоФайла(ВладелецФайла, ЭтотОбъект);
		Исключение
			ПоказатьПредупреждение(Неопределено, ФайловыеФункцииСлужебныйКлиентСервер.ОшибкаСозданияНовогоФайла(
				ИнформацияОбОшибке()));
		КонецПопытки;
		
	Иначе
		
		РаботаСФайламиКлиент.СкопироватьФайл(ВладелецФайла, ФайлОснование);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработка события "ПриАктивизацииСтроки" у "Папки"
&НаКлиенте
Процедура ПапкиПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Папки.ТекущаяСтрока = Неопределено ИЛИ Элементы.Папки.ТекущаяСтрока.Пустая() Тогда
		Элементы.СоздатьФайл.Доступность = Ложь;
		Элементы.КонтекстноеМенюСписокСоздать.Доступность = Ложь;
	Иначе
		Элементы.СоздатьФайл.Доступность = Истина;
		Элементы.КонтекстноеМенюСписокСоздать.Доступность = Истина;
	КонецЕсли;
	
	Если Элементы.Папки.ТекущаяСтрока <> Неопределено Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	КонецЕсли; 
	
КонецПроцедуры

// Процедура обновляет правый список
&НаКлиенте
Процедура ОбработкаОжидания()
	Если Элементы.Папки.ТекущаяСтрока <> Список.Параметры.Элементы.Найти("Владелец").Значение Тогда
		Список.Параметры.УстановитьЗначениеПараметра(
			"Владелец", Элементы.Папки.ТекущаяСтрока);
	КонецЕсли;
КонецПроцедуры

// Процедура обеспечивает вызов механизма экспорта папки в файловую систему
&НаКлиенте
Процедура ЭкспортПапкиВыполнить()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПапкаЭкспорта", Элементы.Папки.ТекущаяСтрока);
	ОткрытьФорму("Справочник.Файлы.Форма.ФормаЭкспортаПапки", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИмпортФайловЗавершен" Тогда
		Элементы.Список.Обновить();
		
		Если Параметр <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = Параметр;
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяСобытия = "ИмпортКаталоговЗавершен" Тогда
		Элементы.Папки.Обновить();
		Элементы.Список.Обновить();
		
		Если Источник <> Неопределено Тогда
			Элементы.Папки.ТекущаяСтрока = Источник;
		КонецЕсли;
	КонецЕсли;

	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" Тогда
		
		Если Параметр <> Неопределено Тогда
			ВладелецФайла = Неопределено;
			Если Параметр.Свойство("Владелец", ВладелецФайла) Тогда
				Если ВладелецФайла = Элементы.Папки.ТекущаяСтрока Тогда
					Элементы.Список.Обновить();
					
					ФайлСозданный = Неопределено;
					Если Параметр.Свойство("Файл", ФайлСозданный) Тогда
						Элементы.Список.ТекущаяСтрока = ФайлСозданный;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		УстановитьДоступностьФайловыхКомманд();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура НайтиВыполнить()
	Если СтрокаПоиска = "" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан текст для поиска.'"), , "СтрокаПоиска");
		Возврат;
	КонецЕсли;
	
	НайтиФайлыИлиПапки();
КонецПроцедуры

&НаКлиенте
Процедура ПоискПриИзменении(Элемент)
	НайтиФайлыИлиПапки();
КонецПроцедуры

&НаКлиенте
Процедура НайтиФайлыИлиПапки()
	
	Если СтрокаПоиска = "" Тогда
		Возврат;
	КонецЕсли;
	
	Результат = НайтиФайлыИлиПапкиСервер();
	Если Результат = "НичегоНеНайдено" Тогда
		ПоказатьПредупреждение(Новый ОписаниеОповещения("НайтиФайлыИлиПапкиЗавершение", ЭтотОбъект, Новый Структура("Результат", Результат)), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		                 НСтр("ru = 'Не удалось найти файл или папку, наименование или код которого содержит ""%1"".'"),
		                 СтрокаПоиска ));
        Возврат;
	Иначе 
		Если Результат = "НайденФайл" Тогда
			ТекущийЭлемент = Элементы.Список;
		Иначе 
			Если Результат = "НайденаПапка" Тогда
				ТекущийЭлемент = Элементы.Папки;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	НайтиФайлыИлиПапкиФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура НайтиФайлыИлиПапкиЗавершение(ДополнительныеПараметры) Экспорт
	
	Результат = ДополнительныеПараметры.Результат;
	
	
	НайтиФайлыИлиПапкиФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура НайтиФайлыИлиПапкиФрагмент()
	
	Элементы.Папки.Обновить();
	Элементы.Список.Обновить();

КонецПроцедуры

&НаСервере
Функция СтрЗаменитьСпецсимволом(Строка, Символ, Спецсимвол)
	СтрокаНовая = СтрЗаменить(Строка, Символ, СпецСимвол + Символ);
	Возврат СтрокаНовая;
КонецФункции	

&НаСервере
Функция НайтиФайлыИлиПапкиСервер()
	
	Перем НайденныйФайл;
	Перем НайденнаяПапка;
	
	Найдено = Ложь;
	
	Запрос = Новый Запрос;
	
	СтрокаПоискаНовая = СтрокаПоиска;
	
	СпецСимвол = "|";
	СтрокаПоискаНовая = СтрЗаменитьСпецсимволом(СтрокаПоискаНовая, "[", СпецСимвол);
	СтрокаПоискаНовая = СтрЗаменитьСпецсимволом(СтрокаПоискаНовая, "]", СпецСимвол);
	
	Запрос.Параметры.Вставить("Строка", "%" + СтрокаПоискаНовая + "%");
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
				   |	Файлы.Ссылка
				   |ИЗ
				   |	Справочник.Файлы КАК Файлы
				   |ГДЕ
				   |	Файлы.ПолноеНаименование ПОДОБНО &Строка СПЕЦСИМВОЛ ""|""";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		НайденныйФайл = Выборка.Ссылка;
		Найдено = Истина;
	КонецЕсли;
	
	Если Не Найдено Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
					   |	Файлы.Ссылка
					   |ИЗ
					   |	Справочник.Файлы КАК Файлы
					   |ГДЕ
					   |	Файлы.Код ПОДОБНО &Строка";
						
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			НайденныйФайл = Выборка.Ссылка;
			Найдено = Истина;
		КонецЕсли;	
	КонецЕсли;	
	
	Если Не Найдено Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
					   |	ПапкиФайлов.Ссылка
					   |ИЗ
					   |	Справочник.ПапкиФайлов КАК ПапкиФайлов
					   |ГДЕ
					   |	ПапкиФайлов.Наименование ПОДОБНО &Строка";
						
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			НайденнаяПапка = Выборка.Ссылка;
			Найдено = Истина;
		КонецЕсли;	
	КонецЕсли;	
	
	Если Не Найдено Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
					   |	ПапкиФайлов.Ссылка
					   |ИЗ
					   |	Справочник.ПапкиФайлов КАК ПапкиФайлов
					   |ГДЕ
					   |	ПапкиФайлов.Код ПОДОБНО &Строка";
						
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			НайденнаяПапка = Выборка.Ссылка;
			Найдено = Истина;
		КонецЕсли;	
	КонецЕсли;	
	
	Если НайденныйФайл <> Неопределено Тогда 
		Элементы.Папки.ТекущаяСтрока = НайденныйФайл.ВладелецФайла;
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
		Элементы.Список.ТекущаяСтрока = НайденныйФайл.Ссылка;
		Возврат "НайденФайл";
	КонецЕсли;
	
	Если НайденнаяПапка <> Неопределено Тогда
		Элементы.Папки.ТекущаяСтрока = НайденнаяПапка;
		Возврат "НайденаПапка";
	КонецЕсли;	
	
	Возврат "НичегоНеНайдено";
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Папка") = Истина И Параметры.Папка <> Неопределено Тогда
		ПапкаПриОткрытии = Параметры.Папка;
	Иначе	
		ПапкаПриОткрытии = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ХранилищеФайлов", "ТекущаяПапка");
	КонецЕсли;
	
	Если ПапкаПриОткрытии = Справочники.ПапкиФайлов.ПустаяСсылка() Тогда
		ПапкаПриОткрытии = ПредопределенноеЗначение("Справочник.ПапкиФайлов.Шаблоны");
	Иначе
		ПапкаПриОткрытииОбъект = Неопределено;
		Попытка
			ПапкаПриОткрытииОбъект = ПапкаПриОткрытии.ПолучитьОбъект();
		Исключение
		КонецПопытки;
		
		Если ПапкаПриОткрытииОбъект = Неопределено Тогда
			ПапкаПриОткрытии = ПредопределенноеЗначение("Справочник.ПапкиФайлов.Шаблоны");
		КонецЕсли;
	КонецЕсли;
	
	Элементы.Папки.ТекущаяСтрока = ПапкаПриОткрытии;

	Список.Параметры.УстановитьЗначениеПараметра(
		"Владелец", ПапкаПриОткрытии);
	Список.Параметры.УстановитьЗначениеПараметра(
		"ТекущийПользователь", Пользователи.ТекущийПользователь());

	РаботаСФайламиВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(Список);
	
	ПоказыватьКолонкуРазмер = РаботаСФайламиВызовСервера.ПолучитьПоказыватьКолонкуРазмер();
	Если ПоказыватьКолонкуРазмер = Ложь Тогда
		Элементы.ТекущаяВерсияРазмер.Видимость = Ложь;
	КонецЕсли;
	
	ИспользоватьИерархию = Истина;
	УстановитьИерархию(ИспользоватьИерархию);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;

	Если ПапкаПриОткрытии <> Элементы.Папки.ТекущаяСтрока Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(
		"ХранилищеФайлов", 
		"ТекущаяПапка", 
		Элементы.Папки.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьФайлВыполнить()
	
	Попытка
		РаботаСФайламиКлиент.СозданиеНовогоФайла(Элементы.Папки.ТекущаяСтрока, ЭтотОбъект);
	Исключение
		ПоказатьПредупреждение(Неопределено, ФайловыеФункцииСлужебныйКлиентСервер.ОшибкаСозданияНовогоФайла(
			ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПапкуВыполнить()
	
	ПараметрыСозданияПапки = Новый Структура("Родитель", Элементы.Папки.ТекущаяСтрока);
	ОткрытьФорму("Справочник.ПапкиФайлов.ФормаОбъекта", ПараметрыСозданияПапки, Элементы.Папки);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Папки.ТекущаяСтрока = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	Если Элементы.Папки.ТекущаяСтрока.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	МассивИменФайлов = Новый Массив;
	ЭтоДрагДропФайловИзвне = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") И ПараметрыПеретаскивания.Значение.ЭтоФайл() = Истина Тогда
		РаботаСФайламиКлиент.СоздатьДокументНаОсновеФайла(ПараметрыПеретаскивания.Значение.ПолноеИмя, Элементы.Папки.ТекущаяСтрока, ЭтотОбъект);
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") Тогда	
		ЭтоДрагДропФайловИзвне = Истина;
		МассивИменФайлов.Добавить(ПараметрыПеретаскивания.Значение.ПолноеИмя);
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		Если ПараметрыПеретаскивания.Значение.Количество() >= 1 И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("Файл") Тогда
			
			ЭтоДрагДропФайловИзвне = Истина;
			Для Каждого ФайлПринятый Из ПараметрыПеретаскивания.Значение Цикл
				МассивИменФайлов.Добавить(ФайлПринятый.ПолноеИмя);
			КонецЦикла;
			
		ИначеЕсли ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование 
			И ПараметрыПеретаскивания.Значение.Количество() >= 1 
			И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("СправочникСсылка.Файлы") Тогда
			
			РаботаСФайламиВызовСервера.СкопироватьФайлы(ПараметрыПеретаскивания.Значение, Элементы.Папки.ТекущаяСтрока);
			Элементы.Папки.Обновить();
			Элементы.Список.Обновить();
			
			Если ПараметрыПеретаскивания.Значение.Количество() = 1 Тогда
				ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Файл ""%1"" скопирован в папку ""%2""'"), ПараметрыПеретаскивания.Значение[0], Строка(Элементы.Папки.ТекущаяСтрока));
				
				ПоказатьОповещениеПользователя(
					НСтр("ru = 'Файл скопирован.'"),
					,
					ПолноеОписание,
					БиблиотекаКартинок.Информация32);
			Иначе
				ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Файлы (%1 шт.) скопированы в папку ""%2""'"), ПараметрыПеретаскивания.Значение.Количество(), Строка(Элементы.Папки.ТекущаяСтрока));
				
				ПоказатьОповещениеПользователя(
					НСтр("ru = 'Файлы скопированы.'"),
					,
					ПолноеОписание,
					БиблиотекаКартинок.Информация32);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоДрагДропФайловИзвне = Истина Тогда
		ПараметрыИмпорта = Новый Структура("ПапкаДляДобавления, МассивИменФайлов", Элементы.Папки.ТекущаяСтрока, МассивИменФайлов);
		ОткрытьФорму("Справочник.Файлы.Форма.ФормаПеретаскивания", ПараметрыИмпорта);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПапкиПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПапкиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	
	МассивИменФайлов = Новый Массив;
	ЭтоДрагДропФайловИзвне = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") И ПараметрыПеретаскивания.Значение.ЭтоФайл() = Истина Тогда
		РаботаСФайламиКлиент.СоздатьДокументНаОсновеФайла(ПараметрыПеретаскивания.Значение.ПолноеИмя, Элементы.Папки.ТекущаяСтрока, ЭтотОбъект);
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") Тогда	
		ЭтоДрагДропФайловИзвне = Истина;
		МассивИменФайлов.Добавить(ПараметрыПеретаскивания.Значение.ПолноеИмя);
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		Если ПараметрыПеретаскивания.Значение.Количество() >= 1 И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("Файл") Тогда
			ЭтоДрагДропФайловИзвне = Истина;
			Для Каждого ФайлПринятый Из ПараметрыПеретаскивания.Значение Цикл
				МассивИменФайлов.Добавить(ФайлПринятый.ПолноеИмя);
			КонецЦикла;
		КонецЕсли;
		
		Если ПараметрыПеретаскивания.Значение.Количество() >= 1 И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("СправочникСсылка.Файлы") Тогда
			
			Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование Тогда
				
				РаботаСФайламиВызовСервера.СкопироватьФайлы(ПараметрыПеретаскивания.Значение, Строка);
				
				Элементы.Папки.Обновить();
				Элементы.Список.Обновить();
				
				Если ПараметрыПеретаскивания.Значение.Количество() = 1 Тогда
					ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Файл ""%1"" скопирован в папку ""%2""'"), ПараметрыПеретаскивания.Значение[0], Строка);
					
					ПоказатьОповещениеПользователя(
						НСтр("ru = 'Файл скопирован.'"),
						,
						ПолноеОписание,
						БиблиотекаКартинок.Информация32);
				Иначе
					ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Файлы (%1 шт.) скопированы в папку ""%2""'"), ПараметрыПеретаскивания.Значение.Количество(), Строка);
					
					ПоказатьОповещениеПользователя(
						НСтр("ru = 'Файлы скопированы.'"),
						,
						ПолноеОписание,
						БиблиотекаКартинок.Информация32);
				КонецЕсли;
				Возврат;
				
			Иначе	
				
				Если РаботаСФайламиВызовСервера.УстановитьВладельцаФайла(ПараметрыПеретаскивания.Значение, Строка) = Истина Тогда
					Элементы.Папки.Обновить();
					Элементы.Список.Обновить();
					
					Если ПараметрыПеретаскивания.Значение.Количество() = 1 Тогда
						ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Файл ""%1"" перенесен в папку ""%2""'"), ПараметрыПеретаскивания.Значение[0], Строка);
						
						ПоказатьОповещениеПользователя(
							НСтр("ru = 'Файл перенесен.'"),
							,
							ПолноеОписание,
							БиблиотекаКартинок.Информация32);
					Иначе
						ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Файлы (%1 шт.) перенесены в папку ""%2""'"), ПараметрыПеретаскивания.Значение.Количество(), Строка);
						
						ПоказатьОповещениеПользователя(
							НСтр("ru = 'Файлы перенесены.'"),
							,
							ПолноеОписание,
							БиблиотекаКартинок.Информация32);
					КонецЕсли;
				КонецЕсли;
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ПараметрыПеретаскивания.Значение.Количество() >= 1 И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
			НайденоЗацикливание = Ложь;
			Если РаботаСФайламиВызовСервера.СменитьРодителяПапок(ПараметрыПеретаскивания.Значение, Строка, НайденоЗацикливание) = Истина Тогда
				Элементы.Папки.Обновить();
				Элементы.Список.Обновить();
				
				Если ПараметрыПеретаскивания.Значение.Количество() = 1 Тогда
					Элементы.Папки.ТекущаяСтрока = ПараметрыПеретаскивания.Значение[0];
					
					ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Папка ""%1"" перенесена в папку ""%2""'"), ПараметрыПеретаскивания.Значение[0], Строка);
					
					ПоказатьОповещениеПользователя(
						НСтр("ru = 'Папка перенесена.'"),
						,
						ПолноеОписание,
						БиблиотекаКартинок.Информация32);
				Иначе
					ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Папки (%1 шт.) перенесены в папку ""%2""'"), ПараметрыПеретаскивания.Значение.Количество(), Строка);
					
					ПоказатьОповещениеПользователя(
						НСтр("ru = 'Папки перенесены.'"),
						,
						ПолноеОписание,
						БиблиотекаКартинок.Информация32);
				КонецЕсли;
				
			Иначе
				Если НайденоЗацикливание = Истина Тогда
					ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Зацикливание уровней.'"));
				КонецЕсли;
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоДрагДропФайловИзвне = Истина Тогда
		ПараметрыИмпорта = Новый Структура("ПапкаДляДобавления, МассивИменФайлов", Строка, МассивИменФайлов);
		ОткрытьФорму("Справочник.Файлы.Форма.ФормаПеретаскивания", ПараметрыИмпорта);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьФайловыхКомманд()
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		Если ТипЗнч(Элементы.Список.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			
			УстановитьДоступностьКомманд(Элементы.Список.ТекущиеДанные.РедактируетТекущийПользователь,
				Элементы.Список.ТекущиеДанные.Редактирует);
			Возврат;	
					
		КонецЕсли;	
			
	КонецЕсли;	
	
	СделатьКомандыНедоступными();
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьКомандыНедоступными()
	
	Элементы.ЗакончитьРедактирование.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокЗакончитьРедактирование.Доступность = Ложь;
	
	Элементы.СохранитьИзменения.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокСохранитьИзменения.Доступность = Ложь;
	
	Элементы.Освободить.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокОсвободить.Доступность = Ложь;
	
	Элементы.Занять.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокЗанять.Доступность = Ложь;
	
	Элементы.Редактировать.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокРедактировать.Доступность = Ложь;
	
	Элементы.ПеренестиВРаздел.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокПеренестиВРаздел.Доступность = Ложь;
		
	Элементы.ОбновитьИзФайлаНаДиске.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокОбновитьИзФайлаНаДиске.Доступность = Ложь;
	
	Элементы.СохранитьКак.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокСохранитьКак.Доступность = Ложь;
	
	Элементы.ОткрытьКаталогФайла.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокОткрытьКаталогФайла.Доступность = Ложь;
	
	Элементы.ОткрытьФайл.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокОткрытьФайл.Доступность = Ложь;
	
КонецПроцедуры



&НаКлиенте
Процедура УстановитьДоступностьКомманд(РедактируетТекущийПользователь, Редактирует)
	
	РедактируетДругой = Не Редактирует.Пустая() И НЕ РедактируетТекущийПользователь;
	
	Элементы.ЗакончитьРедактирование.Доступность = РедактируетТекущийПользователь;
	Элементы.КонтекстноеМенюСписокЗакончитьРедактирование.Доступность = РедактируетТекущийПользователь;
	
	Элементы.СохранитьИзменения.Доступность = РедактируетТекущийПользователь;
	Элементы.КонтекстноеМенюСписокСохранитьИзменения.Доступность = РедактируетТекущийПользователь;
	
	Элементы.Освободить.Доступность = Не Редактирует.Пустая();
	Элементы.КонтекстноеМенюСписокОсвободить.Доступность = Не Редактирует.Пустая();
	
	Элементы.Занять.Доступность = Редактирует.Пустая() ;
	Элементы.КонтекстноеМенюСписокЗанять.Доступность = Редактирует.Пустая() ;
	
	Элементы.Редактировать.Доступность = НЕ РедактируетДругой;
	Элементы.КонтекстноеМенюСписокРедактировать.Доступность = НЕ РедактируетДругой;
	
	Элементы.ПеренестиВРаздел.Доступность = Истина;
	Элементы.КонтекстноеМенюСписокПеренестиВРаздел.Доступность = Истина;
			
	Элементы.ОбновитьИзФайлаНаДиске.Доступность = Истина;
	Элементы.КонтекстноеМенюСписокОбновитьИзФайлаНаДиске.Доступность = Истина;
	
	Элементы.СохранитьКак.Доступность = Истина;
	Элементы.КонтекстноеМенюСписокСохранитьКак.Доступность = Истина;
	
	Элементы.ОткрытьКаталогФайла.Доступность = Истина;
	Элементы.КонтекстноеМенюСписокОткрытьКаталогФайла.Доступность = Истина;
	
	Элементы.ОткрытьФайл.Доступность = Истина;
	Элементы.КонтекстноеМенюСписокОткрытьФайл.Доступность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	УстановитьДоступностьФайловыхКомманд();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьИерархию(Команда)
	
	ИспользоватьИерархию = Не ИспользоватьИерархию;
	Если ИспользоватьИерархию И (Элементы.Список.ТекущиеДанные <> Неопределено) Тогда 
		
		Если Элементы.Список.ТекущиеДанные.Свойство("ВладелецФайла") Тогда 
			Элементы.Папки.ТекущаяСтрока = Элементы.Список.ТекущиеДанные.ВладелецФайла;
		Иначе
			Элементы.Папки.ТекущаяСтрока = Неопределено;
		КонецЕсли;	
		
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
	КонецЕсли;	
	УстановитьИерархию(ИспользоватьИерархию);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИерархию(Отметка)
	
	Если Отметка = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Элементы.ИспользоватьИерархию.Пометка = Отметка;
	Если Отметка = Истина Тогда 
		Элементы.Папки.Видимость = Истина;
	Иначе
		Элементы.Папки.Видимость = Ложь;
	КонецЕсли;
	Список.Параметры.УстановитьЗначениеПараметра("ИспользоватьИерархию", Отметка);
	
КонецПроцедуры	

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьИерархию(Настройки["ИспользоватьИерархию"]);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ КОМАНД РАБОТЫ С ФАЙЛАМИ

&НаКлиенте
Процедура ОткрытьФайлВыполнить()
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(Элементы.Список.ТекущаяСтрока, 
		Неопределено, УникальныйИдентификатор, Неопределено, ПредыдущийАдресФайла);
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	КомандыРаботыСФайламиКлиент.Редактировать(Элементы.Список.ТекущаяСтрока);
	УстановитьДоступностьФайловыхКомманд();
	
КонецПроцедуры


// Доступны файловые команды - есть хотя бы одна строка в списке и выделена не группировка
&НаКлиенте
Функция ФайловыеКомандыДоступны()
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	КомандыРаботыСФайламиКлиент.ЗакончитьРедактирование(
		Элементы.Список.ТекущаяСтрока,
		УникальныйИдентификатор,
		Элементы.Список.ТекущиеДанные.ХранитьВерсии,
		Элементы.Список.ТекущиеДанные.РедактируетТекущийПользователь,
		Элементы.Список.ТекущиеДанные.Редактирует,
		Элементы.Список.ТекущиеДанные.Автор,
		Элементы.Список.ТекущиеДанные.Кодировка);
	
	УстановитьДоступностьФайловыхКомманд();
		
КонецПроцедуры

&НаКлиенте
Процедура Занять(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;

	КомандыРаботыСФайламиКлиент.Занять(Элементы.Список.ТекущаяСтрока);
	
	УстановитьДоступностьФайловыхКомманд();
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	КомандыРаботыСФайламиКлиент.ОсвободитьФайл(
		Элементы.Список.ТекущаяСтрока,
		Элементы.Список.ТекущиеДанные.ХранитьВерсии,
		Элементы.Список.ТекущиеДанные.РедактируетТекущийПользователь,
		Элементы.Список.ТекущиеДанные.Редактирует);
	
	УстановитьДоступностьФайловыхКомманд();
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	КомандыРаботыСФайламиКлиент.ОпубликоватьФайл(
		Элементы.Список.ТекущаяСтрока, 
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(Элементы.Список.ТекущаяСтрока, 
		Неопределено, УникальныйИдентификатор, Неопределено, ПредыдущийАдресФайла);
	КомандыРаботыСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляСохранения(Элементы.Список.ТекущаяСтрока, Неопределено, УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИРабочийКаталог(Элементы.Список.ТекущаяСтрока);
	КомандыРаботыСФайламиКлиент.ОбновитьИзФайлаНаДиске(ДанныеФайла, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	
	ПараметрыОткрытияФормы = Новый Структура("Ключ", Элемент.ТекущаяСтрока);
	ОткрытьФорму("Справочник.Файлы.ФормаОбъекта", ПараметрыОткрытияФормы);
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВПапку(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытияФормы = Новый Структура("Заголовок, ТекущаяПапка", НСтр("ru = 'Выбор папки'"), Элементы.Папки.ТекущаяСтрока);
	Результат = Неопределено;

	ОткрытьФорму("Справочник.ПапкиФайлов.ФормаВыбора", ПараметрыОткрытияФормы,,,,, Новый ОписаниеОповещения("ПеренестиВПапкуЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВПапкуЗавершение(Результат1, ДополнительныеПараметры) Экспорт
	
	Результат = Результат1;
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
	РаботаСФайламиКлиент.ПеренестиФайлыВПапку(ВыделенныеСтроки, Результат);
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		Оповестить("Запись_Файл", Новый Структура("Событие", "ДанныеФайлаИзменены"), ВыделеннаяСтрока);
	КонецЦикла;
	Элементы.Список.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)  
	Если ОбщегоНазначенияКлиентПовтИсп.ЭтоВебКлиентПодMacOS() Тогда
		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	Если ТекущийЭлемент = Элементы.Папки Тогда
		Элементы.Папки.Обновить();
	Иначе		
		Элементы.Список.Обновить();
	КонецЕсли;		
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// КОНЕЦ ПРОЦЕДУР - ОБРАБОТЧИКОВ КОМАНД РАБОТЫ С ФАЙЛАМИ
