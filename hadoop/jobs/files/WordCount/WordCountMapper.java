import java.io.IOException;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.Mapper;
public class WordCountMapper extends Mapper<LongWritable, Text, Text,IntWritable > {
@Override
public void map(LongWritable key, Text value, Context context) throws IOException,
InterruptedException {
String line = value.toString();
for (String word : line.split("\\W+")) {
if (word.length() > 0) {
context.write(new Text(word),new IntWritable(1));
}
}
}
}
