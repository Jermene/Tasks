﻿
////////////////////////////////////////////////////////////////////////////////
// Подсистема "СклоненияПредставленийОбъектов".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает пустую структуру склонения
//
// Возвращаемое значение:
//	 Структура - со свойствами:
//		*ИменительныйПадеж 	- Строка
//		*РодительныйПадеж 	- Строка
//		*ДательныйПадеж 	- Строка
//		*ВинительныйПадеж 	- Строка
//		*ТворительныйПадеж 	- Строка
//		*ПредложныйПадеж 	- Строка
// 
Функция СтруктураСклонения() Экспорт
	
	СтруктураСклонений = Новый Структура("ИменительныйПадеж, 
										 |РодительныйПадеж, 
										 |ДательныйПадеж, 
										 |ВинительныйПадеж, 
										 |ТворительныйПадеж, 
										 |ПредложныйПадеж");
	Возврат СтруктураСклонений;
	
КонецФункции

#КонецОбласти