﻿Процедура ПроверитьИИсправитьВидыКонтактнойИнформации() Экспорт
	МассивВидовКонтактойИнформации = Новый Массив();
	МассивВидовКонтактойИнформации.Добавить(ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.узEmailКонтрагенты"));
	МассивВидовКонтактойИнформации.Добавить(ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.узТелефонКонтрагенты"));
	
	ЕстьОшибки = Ложь;
	Для каждого пВидкКонтактнойИнформации из МассивВидовКонтактойИнформации цикл
		Если НЕ ЗначениеЗаполнено(пВидкКонтактнойИнформации.Тип) Тогда
			ЕстьОшибки = Истина;
		Конецесли;
	Конеццикла;
	
	Если ЕстьОшибки Тогда
		узОбновлениеИнформационнойБазы.ОбновлениеНаВерсию_1_0_3_035();
	Конецесли;
КонецПроцедуры 