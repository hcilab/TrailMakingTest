import java.util.Comparator;
import java.util.List;
import java.util.Arrays;


class TrailAComparator implements Comparator<Circle> {
  int compare(Circle c1, Circle c2) {
    int val1 = Integer.parseInt(c1.text);
    int val2 = Integer.parseInt(c2.text);
    return Integer.compare(val1, val2);
  }
}

class TrailBComparator implements Comparator<Circle> {
  List<String> ordering = Arrays.asList(
    "1", "A", "2", "B", "3", "C", "4", "D", "5", "E", "6", "F", "7", "G", "8",
    "H", "9", "I", "10", "J", "11", "K", "12", "L", "13");

  int compare(Circle c1, Circle c2) {
    int val1 = ordering.indexOf(c1.text);
    int val2 = ordering.indexOf(c2.text);
    assert(val1 != -1 && val2 != -1);
    return Integer.compare(val1, val2);
  }
}
