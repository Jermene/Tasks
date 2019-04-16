﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем СтарыйРодитель; // Значение родителя группы до изменения для использования
                      // в обработчике события ПриЗаписи.

Перем СтарыйСоставГруппыПользователей; // Состав пользователей группы пользователей
                                       // до изменения для использования в обработчике
                                       // события ПриЗаписи.

Перем ЭтоНовый; // Показывает, что был записан новый объект.
                // Используются в обработчике события ПриЗаписи.

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверенныеРеквизитыОбъекта = Новый Массив;
	Ошибки = Неопределено;
	
	// Проверка использования родителя.
	Если Родитель = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"Объект.Родитель",
			НСтр("ru = 'Предопределенная группа ""Все пользователи"" не может быть родителем.'"),
			"");
	КонецЕсли;
	
	// Проверка незаполненных и повторяющихся пользователей.
	ПроверенныеРеквизитыОбъекта.Добавить("Состав.Пользователь");
	
	Для каждого ТекущаяСтрока Из Состав Цикл;
		НомерСтроки = Состав.Индекс(ТекущаяСтрока);
		
		// Проверка заполнения значения.
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.Пользователь) Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.Состав[%1].Пользователь",
				НСтр("ru = 'Пользователь не выбран.'"),
				"Объект.Состав",
				НомерСтроки,
				НСтр("ru = 'Пользователь в строке %1 не выбран.'"));
			Продолжить;
		КонецЕсли;
		
		// Проверка наличия повторяющихся значений.
		НайденныеЗначения = Состав.НайтиСтроки(Новый Структура("Пользователь", ТекущаяСтрока.Пользователь));
		Если НайденныеЗначения.Количество() > 1 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.Состав[%1].Пользователь",
				НСтр("ru = 'Пользователь повторяется.'"),
				"Объект.Состав",
				НомерСтроки,
				НСтр("ru = 'Пользователь в строке %1 повторяется.'"));
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ПроверенныеРеквизитыОбъекта);
	
КонецПроцедуры

// Блокирует недопустимые действия с предопределенной группой "Все пользователи".
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = ЭтоНовый();
	
	Если Ссылка = Справочники.ГруппыПользователей.ВсеПользователи Тогда
		Если НЕ Родитель.Пустая() Тогда
			ВызватьИсключение
				НСтр("ru = 'Предопределенная группа ""Все пользователи""
				           |может быть только в корне.'");
		КонецЕсли;
		Если Состав.Количество() > 0 Тогда
			ВызватьИсключение
				НСтр("ru = 'Добавление пользователей в группу
				           |""Все пользователи"" не поддерживается.'");
		КонецЕсли;
	Иначе
		Если Родитель = Справочники.ГруппыПользователей.ВсеПользователи Тогда
			ВызватьИсключение
				НСтр("ru = 'Предопределенная группа ""Все пользователи""
				           |не может быть родителем.'");
		КонецЕсли;
		
		СтарыйРодитель = ?(
			Ссылка.Пустая(),
			Неопределено,
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Родитель"));
			
		Если ЗначениеЗаполнено(Ссылка)
		   И Ссылка <> Справочники.ГруппыПользователей.ВсеПользователи Тогда
			
			СтарыйСоставГруппыПользователей =
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Состав").Выгрузить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УчастникиИзменений = Новый Соответствие;
	ИзмененныеГруппы   = Новый Соответствие;
	
	Если Ссылка <> Справочники.ГруппыПользователей.ВсеПользователи Тогда
		
		ИзмененияСостава = ПользователиСлужебный.РазличияЗначенийКолонки(
			"Пользователь",
			Состав.Выгрузить(),
			СтарыйСоставГруппыПользователей);
		
		ПользователиСлужебный.ОбновитьСоставыГруппПользователей(
			Ссылка, ИзмененияСостава, УчастникиИзменений, ИзмененныеГруппы);
		
		Если СтарыйРодитель <> Родитель Тогда
			
			Если ЗначениеЗаполнено(Родитель) Тогда
				ПользователиСлужебный.ОбновитьСоставыГруппПользователей(
					Родитель, , УчастникиИзменений, ИзмененныеГруппы);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтарыйРодитель) Тогда
				ПользователиСлужебный.ОбновитьСоставыГруппПользователей(
					СтарыйРодитель, , УчастникиИзменений, ИзмененныеГруппы);
			КонецЕсли;
		КонецЕсли;
		
		ПользователиСлужебный.ОбновитьИспользуемостьСоставовГруппПользователей(
			Ссылка, УчастникиИзменений, ИзмененныеГруппы);
	КонецЕсли;
	
	ПользователиСлужебный.ПослеОбновленияСоставовГруппПользователей(
		УчастникиИзменений, ИзмененныеГруппы);
	
	ИнтеграцияСтандартныхПодсистем.ПослеДобавленияИзмененияПользователяИлиГруппы(Ссылка, ЭтоНовый);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли