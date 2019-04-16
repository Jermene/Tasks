﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Вызывается каждые 20 минут, например, для контроля динамического обновления и
// окончания срока действия учетной записи пользователя.
//
Процедура ОбработчикОжиданияСтандартныхПериодическихПроверок() Экспорт
	
	СтандартныеПодсистемыКлиент.ПриВыполненииСтандартныхПериодическихПроверок();
	
КонецПроцедуры

// Продолжает завершение в режиме интерактивного взаимодействия с пользователем
// после установки Отказ = Истина.
//
Процедура ОбработчикОжиданияИнтерактивнаяОбработкаПередЗавершениемРаботыСистемы() Экспорт
	
	СтандартныеПодсистемыКлиент.НачатьИнтерактивнуюОбработкуПередЗавершениемРаботыСистемы();
	
КонецПроцедуры

// Продолжает запуск в режиме интерактивного взаимодействия с пользователем.
Процедура ОбработчикОжиданияПриНачалеРаботыСистемы() Экспорт
	
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы(, Ложь);
	
КонецПроцедуры

// Вызывается после запуска конфигурации, открывает окно информации.
Процедура ПоказатьИнформациюПослеЗапуска() Экспорт
	МодульИнформацияПриЗапускеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнформацияПриЗапускеКлиент");
	МодульИнформацияПриЗапускеКлиент.Показать();
КонецПроцедуры

// Вызывается после запуска конфигурации, открывает окно предупреждения безопасности.
Процедура ПоказатьПредупреждениеБезопасностиПослеЗапуска() Экспорт
	МодульПользователиСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПользователиСлужебныйКлиент");
	МодульПользователиСлужебныйКлиент.ПоказатьПредупреждениеБезопасности();
КонецПроцедуры

// Показывает сообщение пользователю о недостаточном объеме оперативной памяти.
Процедура ПоказатьРекомендациюПоОбъемуОперативнойПамяти() Экспорт
	СтандартныеПодсистемыКлиент.ОповеститьОНехваткеПамяти();
КонецПроцедуры

#КонецОбласти
