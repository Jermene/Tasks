﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаКоманднойПанели", "КоманднаяПанель");
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ПроизвольныйОбъект", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства

	//// СтандартныеПодсистемы.Печать
	//УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект, Элементы.КоманднаяПанель);
	//// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ПодключитьОбработчикОжидания("СписокПослеАктивизацииСтроки", 0.1, Истина);
	КонецЕсли;
	
	//Если ИмяСобытия = "Запись_узКонтрагенты"
	//   И Элементы.Список.ТекущаяСтрока = Источник Тогда
	//	
	//	ПодключитьОбработчикОжидания("СписокПослеАктивизацииСтроки", 0.1, Истина);
	//КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если СсылкаНаОбъект <> Элементы.Список.ТекущаяСтрока Тогда
		СсылкаНаОбъект = Элементы.Список.ТекущаяСтрока;
		
		ПодключитьОбработчикОжидания("СписокПослеАктивизацииСтроки", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура СписокПослеАктивизацииСтроки()
	
	ЗаполнитьДополнительныеРеквизитыВФорме();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДополнительныеРеквизитыВФорме()
	
	Если ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
		УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(
			ЭтотОбъект, СсылкаНаОбъект.ПолучитьОбъект(), Истина);
	Иначе
		УправлениеСвойствами.УдалитьСтарыеРеквизитыИЭлементы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
