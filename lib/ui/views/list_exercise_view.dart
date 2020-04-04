import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_log_me/models/exercise.dart';

import 'package:scoped_log_me/scoped_models/app_model.dart';
import 'package:scoped_log_me/ui/pages/add_exercise_page.dart';
import 'package:scoped_model/scoped_model.dart';

class ListExercise extends StatefulWidget {
  const ListExercise(
      {Key key,
      this.filter,
      this.isSelectable = false,
      this.hasActions = false})
      : super(key: key);

  final String filter;
  final bool isSelectable;
  final bool hasActions;

  @override
  _ListExerciseState createState() => _ListExerciseState();
}

class _ListExerciseState extends State<ListExercise> {

  
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (x, y, model) {
         int length = model.exercises.length;
        return Expanded(
            // GestureDetector is added for hiding keyboard when swiping down
            child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView.separated(
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Divider(height: 0),
            ),
            itemCount: length,
            itemBuilder: (context, index) {
              // store the object to a local variable
              Exercise exercise = model.exercises[index];
              // Display all when search filter is empty
              return widget.filter == null || widget.filter == ''
                  ? exerciseTile(model, exercise)
                  : (
                      exercise.name.toLowerCase().contains(widget.filter.toLowerCase()) || 
                      describeEnum(exercise.bodyPart).toString().toLowerCase().contains(widget.filter.toLowerCase())
                    )
                      ? exerciseTile(model, exercise)
                      //  : new Column(
                      //     children: <Widget>[
                      //       Text(widget.filter + ' not found'),
                      //     ],
                      //   );
                      : new Container(
                        child:Text('test')
                      );
            },
          ),
        ));
      },
    );
  }

  Widget exerciseTile(AppModel model, Exercise exercise) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      child: Ink(
        color: exercise.isCheck ?
        Theme.of(context).primaryColorLight:
        Theme.of(context).primaryColor,

        child: ListTileTheme(
          dense: true,
          child: ListTile(
            title: new Text(exercise.name ?? 'No name'),
            subtitle: new Text(
                describeEnum(exercise.bodyPart).toString().toUpperCase()),
            onTap: () {
              HapticFeedback.selectionClick();
              if (widget.isSelectable && !widget.hasActions) {
                setState(() {
                  exercise.isCheck = !exercise.isCheck;

                  // Add the exercise only if it is selected
                  if (exercise.isCheck) {
                    print('checked');
                    // Add only if the list already doesn't have the exercise
                    if (!model.selectedExercises.contains(exercise)) {
                      print("list doesn't contains Ex");
                      model.selectExercise(exercise);
                    }
                  } else {
                    print('unchecked');
                    if (model.selectedExercises.contains(exercise)) {
                      print("list contains Ex, need to remove it");
                      model.unselectExercise(exercise);
                    }
                  }
                });
              }
            },
            trailing: (widget.hasActions && !widget.isSelectable)
                ? ButtonBar(
                    alignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: (() => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => AddExercisePage(
                                    model: model,
                                    title: 'Edit Exercise',
                                    isUpdateMode: true,
                                    exercise: exercise)))),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: (() {
                          model.removeExercise(exercise);
                        }),
                      ),
                    ],
                  )
                : exercise.isCheck
                    ? Icon(
                        Icons.done,
                        color: Theme.of(context).accentColor
                      )
                    : Container(width: 1),
          ),
        ),
      ),
    );
  }
}
