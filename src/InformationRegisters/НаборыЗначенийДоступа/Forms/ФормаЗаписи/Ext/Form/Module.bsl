﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВключитьРедактированиеАвтоРеквизитов(Команда)
	
	Элементы.АвтоРеквизиты.ТолькоПросмотр = Ложь;
	РедактированиеАвтоРеквизитов = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьАвтоРеквизиты(Команда)
	
	ЗаполнитьАвтоРеквизитыНаСервере(Истина);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура СвойствоПриИзменении(Элемент)
	
	ЗаполнитьАвтоРеквизитыНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьАвтоРеквизитыНаСервере(ПоКомандеПользователя = Ложь)
	
	Если РедактированиеАвтоРеквизитов И НЕ ПоКомандеПользователя Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.НаборыЗначенийДоступа.СоздатьНаборЗаписей();
	
	ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Запись);
	
	УправлениеДоступомСлужебный.ПодготовкаНаборовЗначенийДоступаПередЗаписью(
		Запись.Объект, НаборЗаписей);
	
	ЗаполнитьЗначенияСвойств(
		Запись,
		НаборЗаписей[0],
		"ВидДоступаЧерезПраваПоЗначениямДоступа,
		|ВидДоступаЕдинственныйДляТипаЗначенияДоступа,
		|ВидДоступаБезГруппЗначенияДоступа,
		|ВидДоступаПравоЧтения,
		|ВидДоступаПравоДобавления,
		|ВидДоступаПравоИзменения,
		|ТипЗначенияДоступа");
	
	Если НЕ Запись.Чтение
	   И НЕ Запись.Добавление
	   И НЕ Запись.Изменение
	   И НЕ Запись.Удаление Тогда
		 
		Запись.ВидДоступаПравоЧтения     = Неопределено;
		Запись.ВидДоступаПравоДобавления = Неопределено;
		Запись.ВидДоступаПравоИзменения  = Неопределено;
	КонецЕсли;
	
	Если ПоКомандеПользователя Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры
