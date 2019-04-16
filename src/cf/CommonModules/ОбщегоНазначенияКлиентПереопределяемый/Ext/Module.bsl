﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// В этом модуле содержится реализация обработчиков модуля приложения. 
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняется перед интерактивным началом работы пользователя с областью данных или в локальном режиме.
//
// Соответствует обработчику ПередНачаломРаботыСистемы.
//
// Параметры:
//  Параметры - Структура - структура со свойствами:
//              Отказ                  - Булево - Возвращаемое значение. Если установить Истина,
//                                       то работа программы будет прекращена.
//              Перезапустить          - Булево - Возвращаемое значение. Если установить Истина и параметр.
//                                       Отказ тоже установлен в Истина, то выполняется перезапуск программы.
//              ДополнительныеПараметрыКоманднойСтроки - Строка - Возвращаемое значение. Имеет смысл
//                                       когда Отказ и Перезапустить установлены Истина.
//              ИнтерактивнаяОбработка - ОписаниеОповещения - Возвращаемое значение. Для открытия окна,
//                                       блокирующего вход в программу, следует присвоить в этот параметр
//                                       описание обработчика оповещения, который открывает окно.
//                                       См. пример ниже.
//              ОбработкаПродолжения   - ОписаниеОповещения - если открывается окно, блокирующее вход
//                                       в программу, то в обработке закрытия этого окна необходимо
//                                       выполнить оповещение ОбработкаПродолжения.
//                                       См. пример ниже.
//
// Пример открытия окна, блокирующего вход в программу:
//
//		Если ОткрытьОкноПриЗапуске Тогда
//			Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ОткрытьОкно", ЭтотОбъект);
//		КонецЕсли;
//
//	Процедура ОткрытьОкно(Параметры, ДополнительныеПараметры) Экспорт
//		// Показываем окно, по закрытию которого вызывается обработчик оповещения ОткрытьОкноЗавершение.
//		Оповещение = Новый ОписаниеОповещения("ОткрытьОкноЗавершение", ЭтотОбъект, Параметры);
//		Форма = ОткрытьФорму(... ,,, ... Оповещение);
//		Если Не Форма.Открыта() Тогда // Если ПриСозданииНаСервере Отказ установлен Истина.
//			ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
//		КонецЕсли;
//	КонецПроцедуры
//
//	Процедура ОткрытьОкноЗавершение(Результат, Параметры) Экспорт
//		...
//		ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
//		
//	КонецПроцедуры
//
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
//
// Соответствует обработчику ПриНачалеРаботыСистемы.
//
// Параметры:
//  Параметры - Структура - структура со свойствами:
//            * Отказ                  - Булево - Возвращаемое значение. Если установить Истина,
//                                       то работа программы будет прекращена.
//            * Перезапустить          - Булево - Возвращаемое значение. Если установить Истина и параметр.
//                                       Отказ тоже установлен в Истина, то выполняется перезапуск программы.
//            * ДополнительныеПараметрыКоманднойСтроки - Строка - Возвращаемое значение. Имеет смысл
//                                       когда Отказ и Перезапустить установлены Истина.
//            * ИнтерактивнаяОбработка - ОписаниеОповещения - Возвращаемое значение. Для открытия окна,
//                                       блокирующего вход в программу, следует присвоить в этот параметр
//                                       описание обработчика оповещения, который открывает окно.
//                                       См. пример выше (для обработчика ПередНачаломРаботыСистемы).
//            * ОбработкаПродолжения   - ОписаниеОповещения - если открывается окно, блокирующее вход
//                                       в программу, то в обработке закрытия этого окна необходимо
//                                       выполнить оповещение ОбработкаПродолжения.
//                                       См. пример выше (для обработчика ПередНачаломРаботыСистемы).
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	

КонецПроцедуры

// Обработать параметры запуска программы.
// Реализация функции может быть расширена для обработки новых параметров.
//
// Параметры:
//  ЗначениеПараметраЗапуска - Строка - первое значение параметра запуска, 
//                                      до первого символа ";".
//  ПараметрыЗапуска  - Строка - параметр запуска, переданный в конфигурацию 
//                               с помощью ключа командной строки /C.
//  Отказ             - Булево - Возвращаемое значение. Если установить Истина,
//                               то выполнение процедуры ПриНачалеРаботыСистемы будет прервано.
//
Процедура ПриОбработкеПараметровЗапуска(ЗначениеПараметраЗапуска, ПараметрыЗапуска, Отказ) Экспорт

КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
// Вызывается после завершения действий ПриНачалеРаботыСистемы.
// Используется для подключения обработчиков ожидания, которые не должны вызываться
// в случае интерактивных действий перед и при начале работы системы.
//
// Начальная страница (рабочий стол) в этот момент еще не открыта, поэтому запрещено открывать
// формы напрямую, а следует использовать для этих целей обработчик ожидания.
// Запрещено использовать это событие для интерактивного взаимодействия с пользователем
// (ПоказатьВопрос и аналогичные действия). Для этих целей следует использовать
// событие ПриНачалеРаботыСистемы, который поддерживает продолжение своего выполнения.
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
КонецПроцедуры

// Выполняется перед интерактивном завершении работы пользователя с областью данных или в локальном режиме.
//
// Соответствует обработчику ПередЗавершениемРаботыСистемы.
//
// Параметры:
//  Параметры - Структура - структура со свойствами:
//            * Отказ                  - Булево - Возвращаемое значение. Если установить Истина,
//                                       то завершение работы программы будет отменено.
//            * ИнтерактивнаяОбработка - ОписаниеОповещения - Возвращаемое значение. Для открытия окна,
//                                       блокирующего выход из программы, следует присвоить в этот параметр
//                                       описание обработчика оповещения, который открывает окно.
//                                       См. пример выше (для обработчика ПередНачаломРаботыСистемы).
//            * ОбработкаПродолжения   - ОписаниеОповещения - если открывается окно, блокирующее выход
//                                       из программы, то в обработке закрытия этого окна необходимо
//                                       выполнить оповещение ОбработкаПродолжения.
//                                       См. пример выше (для обработчика ПередНачаломРаботыСистемы).
//
Процедура ПередЗавершениемРаботыСистемы(Параметры) Экспорт
	
КонецПроцедуры

// Переопределяет заголовок приложения.
//
// Параметры:
//  ЗаголовокПриложения - Строка - текст заголовка приложения;
//  ПриЗапуске - Булево - Истина, если вызывается при начале работы программы.
Процедура ПриУстановкеЗаголовкаКлиентскогоПриложения(ЗаголовокПриложения, ПриЗапуске) Экспорт
	
	
		
КонецПроцедуры

#КонецОбласти
