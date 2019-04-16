﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Загрузка данных из файла".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет список справочников, доступных для загрузки с помощью подсистемы "Загрузка данных из файла".
//
// Параметры:
//  ЗагружаемыеСправочники - ТаблицаЗначений - список справочников, в которые возможна загрузка данных.
//      * ПолноеИмя          - Строка - полное имя справочника (как в метаданных).
//      * Представление      - Строка - представление справочника в списке выбора.
//      * ПрикладнаяЗагрузка - Булево - если Истина, значит справочник использует собственный алгоритм загрузки и
//                                      в модуле менеджера справочника определены функции.
//
Процедура ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти