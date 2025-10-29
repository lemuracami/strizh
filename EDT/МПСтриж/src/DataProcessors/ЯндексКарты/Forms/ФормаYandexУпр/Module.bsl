
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Не ЗначениеЗаполнено(Объект.APIКлюч) Тогда
		Объект.APIКлюч = "ACfO8E0BAAAAs70VdQIA8ebHgBDmBd4Ys3FvUtq5t7LjAU4AAAAAAAAAAADwd85Es0X8nq4nUAzlEm5Cv8_OYg";
	КонецЕсли;
	
	ПостроитьМаршрут();
КонецПроцедуры

&НаСервере
Функция ПостроитьМаршрут()
	
	Результат = Ложь;
	Об = РеквизитФормыВЗначение("Объект");
	Если ЗначениеЗаполнено(Объект.АдресДоставки) И ЗначениеЗаполнено(Объект.АдресОтгрузки) И ЗначениеЗаполнено(Объект.APIКлюч) Тогда
		
		СтруктураАдреса = Новый Структура;
		СтруктураАдреса = Об.ПолучитьСтруктуруАдресаИзСтроки_(Объект.АдресДоставки);
		Объект.АдресДоставки = Об.ПолучитьПредставлениеАдресаДляПоиска(СтруктураАдреса);
		
		Объект.КодХТМЛ = "
		|<!DOCTYPE html PUBLIC ""-//W3C//DTD XHTML 1.0 Transitional//EN"" ""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"">
		|<html xmlns=""http://www.w3.org/1999/xhtml"">
		|<head>
		|    <title>Маршрут доставки</title>
		|    <meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />
		|    <script type=""text/javascript"" src=""http://api-maps.yandex.ru/1.1/index.xml?key=" + Объект.APIКлюч + "==&modules=traffic"" charset=""utf-8"">
		|    </script>
		|    <script type=""text/javascript"">
		|        YMaps.jQuery(
		|            function showAddress () {
		|                var map = new YMaps.Map(YMaps.jQuery(""#YMapsID"")[0]),
		|                    traffic = new YMaps.Traffic.Control({
		|                            showInfoSwitcher: true,
		|                            infoLayerOptions: {
		|                                cursor: YMaps.Cursor.HELP
		|                            }
		|                        }, {
		|                            shown: true,
		|                            infoLayerShown: true
		|                        }
		|                    );
		|
		|                map.setCenter(new YMaps.GeoPoint(37.64, 55.76), 10);
		|                map.addControl(traffic);
		|                var toolBar = new YMaps.ToolBar();
		|                map.addControl(toolBar);
		|                map.addControl(new YMaps.Zoom());
		|                map.addControl(new YMaps.TypeControl());
		|                map.enableScrollZoom();
		|
		|                var router = new YMaps.Router(
		|                    [//~~ТелоФункции~~],
		|                    [],
		|                    { viewAutoApply: true },
		|                    { avoidTrafficJams: traffic.isShown() }
		|                );
		|
		|                map.addOverlay(router);
		|
		//|                YMaps.Events.observe(
		//|                    router, router.Events.Success, function (router) {
		//|                        var route = router.getRoute(0);
		//|                        var itineraryList = ['Количество построенных маршрутов: ' + router.getNumRoutes() + '; Дистанция: ' + Math.round(router.getDistance() /1000) + ' км.; Время в пути: ' + Math.round(router.getDuration()/60) + ' мин.'];
		//|
		//|                        var action = [];
		//|                        action['back'] = 'назад';
		//|                        action['left'] = 'налево';
		//|                        action['right'] = 'направо';
		//|                        action['none'] = 'прямо';
		//|
		//|                        for (var i=0; i < route.getNumRouteSegments(); i++) {
		//|                            var segment = route.getRouteSegment(i);
		//|                            itineraryList.push('Едем ' + action[segment.getAction()] + "" на "" + segment.getStreet() + ', проезжаем ' + segment.getDistance() + ' м.');
		//|                        }
		//|
		//|                        itineraryList.push('Останавливаемся.');
		//|                        alert(itineraryList.join('\n'));
		//|                    }
		//|                );
		|            }
		|        );
		|    </script>
		|</head>
		|<body>
		|    <div id=""YMapsID"" style=""width:800px;height:600px"">
		|    </div>
		|</body>
		|</html>";
		
		//ЭлементыФормы.Карта.УстановитьТекст(КодХТМЛ);
		
		МассивАдресов = Новый Массив;
		МассивАдресов.Добавить(Объект.АдресОтгрузки);
		МассивАдресов.Добавить(Объект.АдресДоставки);
		
		ТелоФункции = "";

		ИндексЭлемента = 1;
		Для Каждого Элемент Из МассивАдресов Цикл 
			Если ИндексЭлемента < МассивАдресов.Количество() Тогда
				ТелоФункции = ТелоФункции + "'" + Элемент + "', ";
				
			Иначе
				ТелоФункции = ТелоФункции + "'" + Элемент + "'";
				
			КонецЕсли;
			ИндексЭлемента = ИндексЭлемента + 1;
		КонецЦикла;
		
		Объект.КодХТМЛ = СтрЗаменить(Объект.КодХТМЛ, "//~~ТелоФункции~~", ТелоФункции);
		
		//ЭлементыФормы.Карта.УстановитьТекст(Объект.КодХТМЛ);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


&НаКлиенте
Процедура Команда1(Команда)
	ПостроитьМаршрут();
КонецПроцедуры

