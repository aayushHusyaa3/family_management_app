// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';

// part 'pick_image_state.dart';

// class PickImageCubit extends Cubit<PickImageState> {
//   PickImageCubit()
//     : super(PickImageState(pickingState: PickingState.initPicking));
//   final ImagePicker picker = ImagePicker();

//   Future<void> pickImageFormGallery() async {
//     final picking = await picker.pickImage(source: ImageSource.gallery);
//      if (picking != null) {
//      final  cropped = await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CropImageScreen(pickedFile: picking),
//         ),
//       );
//     }
//     if (cropped != null) {
//       setState(() {
//         pickedFile = cropped;
//       });
//     }
//   }

//     emit(
//       state.copyWith(pickedFile: picking, pickingState: PickingState.picked),
//     );
//   }

//   Future<void> pickImageFromCamera() async {
//     final picking = await picker.pickImage(source: ImageSource.camera);
//     if (picking != null) {
//       emit(
//         state.copyWith(pickingState: PickingState.picked, pickedFile: picking),
//       );
//     }
//   }

//   // void deleteImage(int index) {
//   //   emit(
//   //     state.copyWith(
//   //       pickingState: PickingState.imageDeleted,
//   //       errorMsg: "Image Deleted Successfully",
//   //     ),
//   //   );
//   //   state.pickedFile!.removeAt(index);
//   // }

//   // void resetPickState() {
//   //   emit(
//   //     state.copyWith(
//   //       pickingState: PickingState.initPicking, // or whatever default
//   //       pickedFile: null,
//   //     ),
//   //   );
//   // }
// }
