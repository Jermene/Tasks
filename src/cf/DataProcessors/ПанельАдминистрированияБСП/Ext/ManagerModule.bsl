﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий базовой функциональности.

// Заполняет переименования тех объектов метаданных, которые невозможно
// автоматически найти по типу, но ссылки на которые требуется сохранять
// в базе данных (например: подсистемы, роли).
//
// Подробнее: см. ОбщегоНазначения.ДобавитьПереименование().
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	Библиотека = "СтандартныеПодсистемы";
	
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.2.1.12",
		"Подсистема.НастройкаИАдминистрирование",
		"Подсистема.Администрирование",
		Библиотека);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов.

// Определяет разделы, в которых доступна панель отчетов.
//   Подробнее - см. описание процедуры ИспользуемыеРазделы
//   общего модуля ВариантыОтчетов.
//
Процедура ПриОпределенииРазделовСВариантамиОтчетов(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.Администрирование, НСтр("ru='Отчеты администратора';en='Administrator reports';ro='Rapoarte de administrator'"));
	
КонецПроцедуры

// Определяет разделы, в которых доступна команда вызова дополнительных отчетов.
//   Подробнее - см. описание функции РазделыДополнительныхОтчетов
//   общего модуля ДополнительныеОтчетыИОбработки.
//
Процедура ПриОпределенииРазделовСДополнительнымиОтчетами(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.Администрирование);
	
КонецПроцедуры

// Определяет разделы, в которых доступна команда вызова дополнительных обработок.
//   Подробнее - см. описание функции РазделыДополнительныхОбработок
//   общего модуля ДополнительныеОтчетыИОбработки.
//
Процедура ПриОпределенииРазделовСДополнительнымиОбработками(Разделы) Экспорт
	
	Разделы.Добавить(Метаданные.Подсистемы.Администрирование);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
