﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура формирует строки списка участников.
//
// Параметры:
//  Контакты  - Массив - массив структур, описывающих участников взаимодействия.
//
Процедура ЗаполнитьКонтакты(Контакты) Экспорт
	
	Взаимодействия.ЗаполнитьКонтактыДляВстречи(Контакты, Адресаты, Перечисления.ТипыКонтактнойИнформации.Телефон);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Взаимодействия.ЗаполнитьРеквизитыПоУмолчанию(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Тема = ВзаимодействияКлиентСервер.ТемаПоТекстуСообщения(ТекстСообщения);
	Взаимодействия.СформироватьСписокУчастников(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Взаимодействия.ПриЗаписиДокумента(ЭтотОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ



#КонецОбласти

#КонецЕсли