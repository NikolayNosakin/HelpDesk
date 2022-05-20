﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Напоминания пользователя".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает форму текущих оповещений пользователя
Функция ПолучитьФормуОповещения() Экспорт
	Возврат ПолучитьФорму("РегистрСведений.НапоминанияПользователя.Форма.ФормаОповещения");
КонецФункции

// Выполняет запрос по напоминаниям для текущего пользователя на 30 минут вперёд от текущего времени.
// Момент времени смещён от текущего для того, чтобы данные были актуальны в течение жизни кэша.
// При обработке результата выполнения функции необходимо учитывать эту особенность.
//
// Параметры
//	Нет
//
// Возвращаемое значение
//  Массив - таблица значений, сконвертированная в массив из структур, содержащих данные строк таблицы.
Функция ПолучитьНапоминанияТекущегоПользователя() Экспорт
	Возврат НапоминанияПользователяВызовСервера.ПолучитьНапоминанияТекущегоПользователя();
КонецФункции