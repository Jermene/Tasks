﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Варианты отчетов" (вызов сервера).
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Открывает форму дополнительного отчета с заданным вариантом.
//
// Параметры:
//   Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка дополнительного отчета.
//   КлючВарианта - Строка - Имя варианта дополнительного отчета.
//
Функция ПараметрыОткрытия(ВариантСсылка) Экспорт
	Возврат ВариантыОтчетов.ПараметрыОткрытия(ВариантСсылка);
КонецФункции

// Открывает форму дополнительного отчета с заданным вариантом.
//
// Параметры:
//   Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка дополнительного отчета.
//   КлючВарианта - Строка - Имя варианта дополнительного отчета.
//
Процедура ПриПодключенииОтчета(ПараметрыОткрытия) Экспорт
	ВариантыОтчетов.ПриПодключенииОтчета(ПараметрыОткрытия);
КонецПроцедуры

#КонецОбласти

