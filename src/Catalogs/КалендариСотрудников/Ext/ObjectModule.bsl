﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ДозаполнитьПоУмолчанию();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
		
	ДополнительныеСвойства.Вставить("ИзмененаОтметкаСинхронизироватьСGoogle", Ложь);
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	//Если ПометкаУдаления Тогда
	//	СинхронизироватьСGoogle = Ложь;
	//КонецЕсли;
	
//	ДополнительныеСвойства.ИзмененаОтметкаСинхронизироватьСGoogle = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "СинхронизироватьСGoogle") <> СинхронизироватьСGoogle;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДозаполнитьПоУмолчанию()
	
	Если Не ЗначениеЗаполнено(ВладелецКалендаря) Тогда
		
		СотрудникиПользователя = ЗаполнениеОбъектовCRM.ПолучитьСотрудниковПользователя();
		
		Если СотрудникиПользователя.Количество() > 0 Тогда
			ВладелецКалендаря = СотрудникиПользователя[0];
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Пользователь) Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли