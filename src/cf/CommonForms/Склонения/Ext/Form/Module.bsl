﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Склонения") И Параметры.Склонения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.Склонения);
		Склонения = Параметры.Склонения;
	КонецЕсли;
	
	Если Параметры.Свойство("ЭтоФИО") Тогда
		ЭтоФИО = Параметры.ЭтоФИО;
	КонецЕсли;
	
	Если Параметры.Свойство("Пол") Тогда
		Пол = Параметры.Пол;
	КонецЕсли;
	
	Если Параметры.Свойство("Представление") Тогда
		Представление = Параметры.Представление;
	КонецЕсли;
	
	Если Параметры.Свойство("ИзмененоПредставление") Тогда
		ИзмененоПредставление = Параметры.ИзмененоПредставление;		
	КонецЕсли;   
	
	ОбновитьГруппуИнформационнаяНадписьСервисСклонения()
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДлительнаяОперация = ПросклонятьПредставлениеПоВсемПадежам();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);

	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПросклонятьПредставлениеПоВсемПадежамЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	СтруктураСклонения = СклонениеПредставленийОбъектовКлиентСервер.СтруктураСклонения();
	ЗаполнитьЗначенияСвойств(СтруктураСклонения, ЭтотОбъект);	
				
	Закрыть(СтруктураСклонения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПросклонятьПовторно(Команда)
	
	ПросклонятьПовторноНаСервере();	
	ОбновитьГруппуИнформационнаяНадписьСервисСклонения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПросклонятьПредставлениеПоВсемПадежам()
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("Представление", Представление);
	ПараметрыПроцедуры.Вставить("ЭтоФИО", ЭтоФИО);
	ПараметрыПроцедуры.Вставить("Пол", Пол);
	ПараметрыПроцедуры.Вставить("ИзмененоПредставление", ИзмененоПредставление);
	ПараметрыПроцедуры.Вставить("Склонения", Склонения);
		
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Склонение представления'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("СклонениеПредставленийОбъектов.ПросклонятьПредставлениеПоВсемПадежамДлительнаяОперация", 
		ПараметрыПроцедуры, ПараметрыВыполнения);   	
	
КонецФункции

&НаКлиенте
Процедура ПросклонятьПредставлениеПоВсемПадежамЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	СтруктураСклонений = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Если ТипЗнч(СтруктураСклонений) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураСклонений);
		Склонения = Новый ФиксированнаяСтруктура(СтруктураСклонений);
	КонецЕсли;
	
	ОбновитьГруппуИнформационнаяНадписьСервисСклонения();
	
КонецПроцедуры 

&НаСервере
Процедура ОбновитьГруппуИнформационнаяНадписьСервисСклонения()
	
	Если ЭтоФИО Тогда
		Элементы.ГруппаИнформационнаяНадписьСервисСклонения.Видимость = Ложь;
		Возврат;
	КонецЕсли;

	ИспользоватьСервисСклонения = Константы.ИспользоватьСервисСклоненияMorpher.Получить();
	
	Если ИспользоватьСервисСклонения Тогда                                                     
		Если Не СклонениеПредставленийОбъектов.ДоступенСервисСклонения() Тогда
			Элементы.ГруппаИнформационнаяНадписьСервисСклонения.Видимость = Истина;
			Элементы.ГруппаИнформационнаяНадписьСервисСклонения.ТекущаяСтраница = Элементы.ГруппаИнформационнаяНадписьДоступностьСервиса;
		Иначе
			Элементы.ГруппаИнформационнаяНадписьСервисСклонения.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ГруппаИнформационнаяНадписьСервисСклонения.Видимость = Истина;
		Элементы.ГруппаИнформационнаяНадписьСервисСклонения.ТекущаяСтраница = Элементы.ГруппаИнформационнаяНадписьВключениеСервиса;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПросклонятьПовторноНаСервере()
	
	ИзмененоПредставление = Истина;
	СтруктураСклонения = СклонениеПредставленийОбъектов.ДанныеСклонения(Представление, ЭтоФИО, Пол, Истина);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураСклонения);
	Склонения = Новый ФиксированнаяСтруктура(СтруктураСклонения);	
	ИзмененоПредставление = Ложь;
	
КонецПроцедуры

#КонецОбласти

