package com.food.searcher.domain;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString

public class AskVO {
	private long askId;
	private String memberId;
	private long itemId;
	private String askContent;
	private Date askDate;
	private int answerCount;
}
