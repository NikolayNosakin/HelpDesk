﻿
&НаКлиенте
Процедура СотрудникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//СтандартнаяОбработка = Ложь;
	//РаботаСПользователямиКлиент.ВыбратьИсполнителя(Элемент, Объект.Сотрудник,,,,
	//		Неопределено, 
	//		Неопределено,Ложь,Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	РассчитатьКоличествоДней();
	ЗаполнитьНаименование();
КонецПроцедуры

&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	РассчитатьКоличествоДней();
	ЗаполнитьНаименование();
КонецПроцедуры

Процедура РассчитатьКоличествоДней()
	Если ЗначениеЗаполнено(Объект.ДатаНачала) И Объект.ДатаОкончания>Объект.ДатаНачала Тогда
		Объект.КоличествоДней = Окр((КонецДня(Объект.ДатаОкончания)-НачалоДня(Объект.ДатаНачала))/86400,0);
	Иначе
		Объект.КоличествоДней = 0;
	КонецЕсли;	
КонецПроцедуры

Процедура ЗаполнитьНаименование()
	Если ЗначениеЗаполнено(Объект.КоличествоДней) Тогда
		Объект.Наименование = Формат(Объект.ДатаНачала,"ДФ=dd.MM.yyyy") + " по "+Формат(Объект.ДатаОкончания,"ДФ=dd.MM.yyyy");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ИзмененаЗаписьОКомандировке", , ЭтотОбъект);
КонецПроцедуры
