﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Свойства"
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Заполняет наборы свойств объекта. Обычно требуется, если наборов более одного.
//
// Параметры:
//  Объект       - Ссылка на владельца свойств.
//                 Объект владельца свойств.
//                 ДанныеФормыСтруктура (по типу объекта владельца свойств).
//
//  ТипСсылки    - Тип - тип ссылки владельца свойств.
//
//  НаборыСвойств - ТаблицаЗначений с колонками:
//                    Набор - СправочникСсылка.НаборыДополнительныхРеквизитовИСведений.
//
//                    // Далее свойства элемента формы типа ГруппаФормы вида обычная группа
//                    // или страница, которая создается, если наборов больше одного без учета
//                    // пустого набора, который описывает свойства группы удаленных реквизитов.
//                    
//                    // Если значение Неопределено, значит использовать значение по умолчанию.
//                    
//                    // Для любой группы управляемой формы.
//                    Высота                   - Число.
//                    Заголовок                - Строка.
//                    Подсказка                - Строка.
//                    РастягиватьПоВертикали   - Булево.
//                    РастягиватьПоГоризонтали - Булево.
//                    ТолькоПросмотр           - Булево.
//                    ЦветТекстаЗаголовка      - Цвет.
//                    Ширина                   - Число.
//                    ШрифтЗаголовка           - Шрифт.
//                    
//                    // Для обычной группы и страницы.
//                    Группировка              - ГруппировкаПодчиненныхЭлементовФормы.
//                    
//                    // Для обычной группы.
//                    Отображение                - ОтображениеОбычнойГруппы.
//                    ШиринаПодчиненныхЭлементов - ШиринаПодчиненныхЭлементовФормы.
//                    
//                    // Для страницы.
//                    Картинка                 - Картинка.
//                    ОтображатьЗаголовок      - Булево.
//
//  СтандартнаяОбработка - Булево - начальное значение Истина. Указывает получать ли
//                         основной набор, когда НаборыСвойств.Количество() равно нулю.
//
Процедура ЗаполнитьНаборыСвойствОбъекта(Объект, ТипСсылки, НаборыСвойств, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

// Возвращает имя реквизита, содержащего вид владельцев свойств (если есть).
// Если возвращается имя реквизита, то вид владельцев свойств
// (например, вид номенклатуры), должен содержать реквизит НаборСвойств
// типа СправочникСсылка.НаборыДополнительныхРеквизитовИСведений.
//
// Параметры:
//  Ссылка       - Ссылка владельца свойств.
//
// Возвращаемые значения:
//  Строка - имя реквизита или пустая строка.
//
Функция ПолучитьИмяРеквизитаВидаОбъекта(Ссылка) Экспорт
	
	
	
	Возврат "";
	
КонецФункции



