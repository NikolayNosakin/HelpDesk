﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьКраткоеИмяПользователяИБ(Знач ПолноеИмя) Экспорт
	
	Разделители = Новый Массив;
	Разделители.Добавить(" ");
	Разделители.Добавить(".");
	
	КраткоеИмя = "";
	Для Счетчик = 1 По 3 Цикл
		
		Если Счетчик <> 1 Тогда
			КраткоеИмя = КраткоеИмя + ВРег(Лев(ПолноеИмя, 1));
		КонецЕсли;
		
		ПозицияРазделителя = 0;
		Для каждого Разделитель Из Разделители Цикл
			ПозицияТекущегоРазделителя = СтрНайти(ПолноеИмя, Разделитель);
			Если ПозицияТекущегоРазделителя > 0
			   И (    ПозицияРазделителя = 0
			      ИЛИ ПозицияРазделителя > ПозицияТекущегоРазделителя ) Тогда
				ПозицияРазделителя = ПозицияТекущегоРазделителя;
			КонецЕсли;
		КонецЦикла;
		
		Если ПозицияРазделителя = 0 Тогда
			Если Счетчик = 1 Тогда
				КраткоеИмя = ПолноеИмя;
			КонецЕсли;
			Прервать;
		КонецЕсли;
		
		Если Счетчик = 1 Тогда
			КраткоеИмя = Лев(ПолноеИмя, ПозицияРазделителя - 1);
		КонецЕсли;
		
		ПолноеИмя = Прав(ПолноеИмя, СтрДлина(ПолноеИмя) - ПозицияРазделителя);
		Пока Разделители.Найти(Лев(ПолноеИмя, 1)) <> Неопределено Цикл
			ПолноеИмя = Сред(ПолноеИмя, 2);
		КонецЦикла;
	КонецЦикла;
	
	Возврат КраткоеИмя;
	
КонецФункции
