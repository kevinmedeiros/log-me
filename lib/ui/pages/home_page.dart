import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/scoped_models/workout_model.dart';
import 'package:scoped_log_me/ui/pages/add_exercise_page.dart';
import 'package:scoped_log_me/ui/pages/select_exercise_page.dart';
import 'package:scoped_log_me/ui/pages/list_workout_page.dart';
import 'package:scoped_log_me/ui/pages/start_workout_page.dart';
import 'package:scoped_log_me/ui/views/display_exercise_view.dart';
import 'package:scoped_log_me/ui/views/list_exercise_view.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.workoutModel, this.model}) : super(key: key);

  final WorkoutModel workoutModel;
  final AppModel model;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool unfinishedWorkout = false;

  @override
  void initState() {
    super.initState();
    print('getting all the exercises');
    widget.model.getAllExercises();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: widget.model,
      child: Scaffold(
          appBar: AppBar(title: Text('Log me')),
          body: Column(
            children: [
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Add Exercises'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              AddExercisePage(model: widget.model)));
                    },
                  ),
                  RaisedButton(
                    child: Text('Display Exercises'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DisplayExercise(model: widget.model)));
                    },
                  ),
                  RaisedButton(
                    child: Text('Select Exercises'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              SelectExercisePage(model: widget.model)));
                    },
                  ),
                  RaisedButton(
                    child: Text('Completed Workouts'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ListWorkoutPage(model: widget.workoutModel)));
                    },
                  ),
                  RaisedButton(
                    child: !this.unfinishedWorkout
                        ? Text('Start a new workout')
                        : Text('Continue workout'),
                    onPressed: () {
                      HapticFeedback.heavyImpact();

                      if (!this.unfinishedWorkout) {
                        widget.workoutModel.startWorkout();
                        setState(() => this.unfinishedWorkout = true);
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StartWorkoutPage(
                              model: widget.model,
                              workoutModel: widget.workoutModel,
                              onCancel: (() => setState(
                                  () => this.unfinishedWorkout = false)),
                              onFinish: (() => setState(
                                  () => this.unfinishedWorkout = false)))));
                    },
                  ),
                ],
              ),
              // AddExercise(),
              ListExercise(),
            ],
          )),
    );
  }
}
