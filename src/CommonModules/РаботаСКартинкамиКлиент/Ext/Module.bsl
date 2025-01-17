﻿// Устанавливает компоненту сканирования
Процедура УстановитьКомпоненту(ОбработчикРезультата) Экспорт

	Если КомпонентаПолученияКартинкиИзБуфера = Неопределено Тогда
		КодВозврата = Неопределено;

		НачатьПодключениеВнешнейКомпоненты(Новый ОписаниеОповещения("УстановитьКомпонентуЗавершение", ЭтотОбъект, Новый Структура("ОбработчикРезультата", ОбработчикРезультата)), "ОбщийМакет.КомпонентаПолученияКартинкиИзБуфера", "ImageFromClipboard", ТипВнешнейКомпоненты.Native);	
	Иначе
		Состояние(НСтр("ru = 'Компонента сканирования уже установлена.'"));
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьКомпонентуЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	
	ОбработчикРезультата = ДополнительныеПараметры.ОбработчикРезультата;
	
	
	КодВозврата = Подключено;
	
	Если КодВозврата Тогда
		Состояние(НСтр("ru = 'Компонента сканирования уже установлена.'"));
	Иначе
		
		ПараметрыВыполнения = Новый Структура;
		ПараметрыВыполнения.Вставить("ОбработчикРезультата", ОбработчикРезультата);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
		"НачатьУстановкуВнешнейКомпонентыПродолжение",
		ЭтотОбъект,
		ПараметрыВыполнения);
		НачатьУстановкуВнешнейКомпоненты(ОписаниеОповещения, "ОбщийМакет.КомпонентаПолученияКартинкиИзБуфера");		
		Возврат;
		
	КонецЕсли;
	КомпонентаПолученияКартинкиИзБуфера = Новый("AddIn.ImageFromClipboard.AddInNativeExtension");

КонецПроцедуры

// Продолжение установки компоненты
Процедура НачатьУстановкуВнешнейКомпонентыПродолжение(ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияДляПодключения = Новый Структура;
	ПараметрыВыполненияДляПодключения.Вставить("ОбработчикРезультата", ПараметрыВыполнения.ОбработчикРезультата);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"НачатьПодключениеВнешнейКомпонентыПродолжение",
		ЭтотОбъект,
		ПараметрыВыполненияДляПодключения);
	
	НачатьПодключениеВнешнейКомпоненты(ОписаниеОповещения, 
		"ОбщийМакет.КомпонентаПолученияКартинкиИзБуфера", 
		"ImageFromClipboard", 
		ТипВнешнейКомпоненты.Native);
	
КонецПроцедуры

// Продолжение установки компоненты
Процедура НачатьПодключениеВнешнейКомпонентыПродолжение(Подключена, ПараметрыВыполнения) Экспорт
	
	Если Подключена Тогда
	
		КомпонентаПолученияКартинкиИзБуфера = Новый("AddIn.ImageFromClipboard.AddInNativeExtension");	
		ВыполнитьОбработкуОповещения(ПараметрыВыполнения.ОбработчикРезультата, Подключена);
		
	КонецЕсли;
	
КонецПроцедуры

// Проинициализировать компоненту сканирования
Функция ПроинициализироватьКомпоненту() Экспорт
	
	Если КомпонентаПолученияКартинкиИзБуфера = Неопределено Тогда
		КодВозврата = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаПолученияКартинкиИзБуфера", "ImageFromClipboard", ТипВнешнейКомпоненты.Native);
		
		Если Не КодВозврата Тогда
			Возврат Ложь;
		КонецЕсли;

		КомпонентаПолученияКартинкиИзБуфера = Новый("AddIn.ImageFromClipboard.AddInNativeExtension");	
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Вернет версию компоненты сканирования
Функция ВерсияКомпоненты() Экспорт

	Если Не ПроинициализироватьКомпоненту() Тогда
		Возврат НСтр("ru= 'Компонента не установлена'");
	КонецЕсли;
	
	Возврат КомпонентаПолученияКартинкиИзБуфера.Версия();
	
КонецФункции // ВерсияКомпонентыСканирования()
