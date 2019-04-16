﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем НастройкаВключена; // Флажок изменения значения константы с Ложь на Истина.
                         // Используется в обработчике события ПриЗаписи.

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаВключена = Значение И НЕ Константы.ИспользоватьДатыЗапретаЗагрузки.Получить();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Не ДополнительныеСвойства.Свойство("ПропуститьОбновлениеВерсииДатЗапретаИзменения") Тогда
		ДатыЗапретаИзмененияСлужебный.ОбновитьВерсиюДатЗапретаИзменения();
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкаВключена Тогда
		СвойстваРазделов = ДатыЗапретаИзмененияСлужебный.СвойстваРазделов();
		Если Не СвойстваРазделов.ДатыЗапретаЗагрузкиВнедрены Тогда
			ВызватьИсключение ДатыЗапретаИзмененияСлужебный.ТекстОшибкиДатыЗапретаЗагрузкиНеВнедрены();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
