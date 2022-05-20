﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Отключает стандартный способ установки ролей пользователям ИБ.
// Если возвращает Истина, изменение ролей блокируется (в том числе для администратора).
//
// Возвращаемое значение:
//  Булево.
//
Функция ЗапретРедактированияРолей() Экспорт
	
	
	
	Возврат Истина;
	
КонецФункции

// Переопределяет роль, предоставляющую права администрирования системы.
//
// Параметры:
//  Роль         - ОбъектМетаданных: Роль.
//
Процедура ИзменитьРольАдминистратораСистемы(Роль) Экспорт
	
	
	
КонецПроцедуры

// Переопределяет поведение форм пользователя, внешнего пользователя,
// группы внешних пользователей.
//
// Параметры:
//  Ссылка - СправочникСсылка.Пользователи,
//           СправочникСсылка.ВнешниеПользователи,
//           СправочникСсылка.ГруппыВнешнихПользователей
//           ссылка на пользователя, внешнего пользователя или группу внешних пользователей
//           при создании формы.
//
//  ДействияВФорме - Структура (со свойствами типа Строка):
//           Роли                   = "", "Просмотр",     "Редактирование"
//           КонтактнаяИнформация   = "", "Просмотр",     "Редактирование"
//           СвойстваПользователяИБ = "", "ПросмотрВсех", "РедактированиеВсех", РедактированиеСвоих"
//           СвойстваЭлемента       = "", "Просмотр",     "Редактирование"
//           
//           Для групп внешних пользователей КонтактнаяИнформация и СвойстваПользователяИБ не существуют.
//
Процедура ИзменитьДействияВФорме(Знач Ссылка = Неопределено, Знач ДействияВФорме) Экспорт
	
	
	
КонецПроцедуры

// Доопределяет действия при записи пользователя информационной базы.
//  Вызывается из процедуры ЗаписатьПользователяИБ(), если пользователь был действительно изменен.
//
// Параметры:
//  СтарыеСвойства - Структура, см. параметры возвращаемые функцией Пользователи.ПрочитатьПользователяИБ()
//  НовыеСвойства  - Структура, см. параметры возвращаемые функцией Пользователи.ЗаписатьПользователяИБ()
//
Процедура ПриЗаписиПользователяИнформационнойБазы(Знач СтарыеСвойства, Знач НовыеСвойства) Экспорт
	
	
	
КонецПроцедуры

// Доопределяет действия после удаления пользователя информационной базы.
//  Вызывается из процедуры УдалитьПользователяИБ(), если пользователь был удален.
//
// Параметры:
//  СтарыеСвойства - Структура, см. параметры возвращаемые функцией Пользователи.ПрочитатьПользователяИБ()
//
Процедура ПослеУдаленияПользователяИнформационнойБазы(Знач СтарыеСвойства) Экспорт
	
	
	
КонецПроцедуры

