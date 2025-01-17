﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяАдминистратораОбновления = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	РезультатОбновления = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗавершитьОбновление(Команда)
	
	ЗавершитьОбновлениеСервер();
	ОткрытьФорму("Обработка.ОбновлениеКонфигурации.Форма");
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьОбновлениеСервер()
	
	//ОбновлениеКонфигурации.ЗавершитьОбновление(РезультатОбновления, АдресЭлектроннойПочты, ИмяАдминистратораОбновления);
	
КонецПроцедуры

