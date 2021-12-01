import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/weather/weather.dart';
import 'package:weatherapp/weather/weather_repository/lib/weather_repository.dart';

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit(context.read<WeatherRepository>()),
      child: WeatherView(),
    );
  }
}

class WeatherView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<WeatherCubit, WeatherState>(
          listener: (context, state) {
            // if (state.status.isSuccess) {
            //   context.read<ThemeCubit>().updateTheme(state.weather);
            // }
          },
          builder: (context, state) {
            switch (state.status) {
              case WeatherStatus.initial:
                return const WeatherEmpty();
              case WeatherStatus.loading:
                return const WeatherLoading();
              case WeatherStatus.success:
                return WeatherPopulated(
                  weather: state.weather,
                  units: state.temperatureUnits,
                  onRefresh: () {
                    return context.read<WeatherCubit>().refreshWeather();
                  },
                );
              case WeatherStatus.failure:
              default:
                return const WeatherError();
            }
          },
        ),
      ),
    );
  }
}
