﻿
&НаСервере
Процедура УстановитьПодразделение()
	
	МенеджерЗаписи = РегистрыСведений.СведенияОПользователях.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Пользователь = Объект.Руководитель;
	МенеджерЗаписи.Прочитать();
		
	МенеджерЗаписи.Пользователь = Объект.Руководитель;
	МенеджерЗаписи.Подразделение = Объект.Ссылка;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтарыйРуководитель = Объект.Руководитель;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.Руководитель) И Объект.Руководитель <> СтарыйРуководитель Тогда 
		
		ПодразделениеРуководителя = РаботаСПользователями.ПолучитьПодразделение(Объект.Руководитель);
		Если Не ЗначениеЗаполнено(ПодразделениеРуководителя) Тогда 
			УстановитьПодразделение();
		ИначеЕсли ПодразделениеРуководителя <> Объект.Ссылка Тогда 
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Пользователь ""%1"" входит в подразделение ""%2"". Переместить его в подразделение ""%3""?'"),
					Строка(Объект.Руководитель),
					Строка(ПодразделениеРуководителя),
					Строка(Объект.Ссылка));
			
			Реультат = Неопределено;

			
			ПоказатьВопрос(Новый ОписаниеОповещения("ПослеЗаписиЗавершение", ЭтотОбъект), ТекстВопроса, РежимДиалогаВопрос.ДаНет);
            Возврат;
		КонецЕсли;	
		
	КонецЕсли;	
	ПослеЗаписиФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Реультат = РезультатВопроса;
	Если Реультат = КодВозвратаДиалога.Да Тогда 
		УстановитьПодразделение();
	КонецЕсли;
	
	ПослеЗаписиФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиФрагмент()
	
	СтарыйРуководитель = Объект.Руководитель;
	
КонецПроцедуры



