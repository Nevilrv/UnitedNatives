import 'package:cached_network_image/cached_network_image.dart';
import 'package:united_natives/medicle_center/lib/utils/translate.dart';
import 'package:united_natives/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../routes/routes.dart';

class ContainerBlogPageDoctor extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool? obscureText;
  final String? error;
  final TextInputType? keyboardType;
  final Function? validator;

  const ContainerBlogPageDoctor({
    super.key,
    this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText,
    this.error,
    this.validator,
  });

  @override
  State<ContainerBlogPageDoctor> createState() =>
      _ContainerBlogPageDoctorState();
}

class _ContainerBlogPageDoctorState extends State<ContainerBlogPageDoctor> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(Routes.catagoryblogdoctor);
          },
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                      bottom: 16, top: 10, right: 10, left: 10),
                  height: 150,
                  child: Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://images.squarespace-cdn.com/content/v1/51e3efc5e4b07f69602a5c7c/1480479771758-E1FJHMJBNCLGDZBWZA5J/ke17ZwdGBToddI8pDm48kA733fzS50f-Ct-n-9EfTroUqsxRUqqbr1mOJYKfIPR7LoDQ9mXPOjoJoqy81S2I8N_N4V1vUb5AoIIIbLZhVYy7Mythp_T-mtop-vrsUOmeInPi9iDjx9w8K4ZfjXt2di2tC53YMP5TA8ma5TVJS0apUIQU7ZKWU4S4OhPmE7n6CjLISwBs8eEdxAxTptZAUg/image-asset.png?format=1500w',
                          imageBuilder: (context, imageProvider) => Container(
                            width: 420.0,
                            height: 400.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              // Center(child: CircularProgressIndicator()),
                              Center(
                            child: Utils.circular(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Container(
                        height: 170,
                        decoration: BoxDecoration(
                            color: Colors.black45.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(Routes.catagoryblogdoctor);
                              },
                              child: Text(
                                Translate.of(context)!
                                    .translate('Current Research'),
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                        fontSize: 27,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            const Text(
                              "USA",
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            const Text(
                              "",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 0,
                ),
                BlogListItem(),
              ]),
        ),
      ),
    );
  }
}

class BlogListItem extends StatelessWidget {
  const BlogListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.pCatagoryBlog);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, top: 10, right: 10, left: 10),
        height: 150,
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl:
                    'https://adigaskell.org/wp-content/uploads/2016/05/employee-participation.jpg',
                imageBuilder: (context, imageProvider) => Container(
                  width: 420.0,
                  height: 400.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) =>
                    // Center(child: CircularProgressIndicator()),
                    Center(
                  child: Utils.circular(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Container(
              height: 170,
              decoration: BoxDecoration(
                  color: Colors.black45.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(6)),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routes.pCatagoryBlog);
                    },
                    child: Text(
                      Translate.of(context)!.translate('Participate'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 27,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
