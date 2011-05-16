// This file is part of AceWiki.
// Copyright 2008-2011, Tobias Kuhn.
// 
// AceWiki is free software: you can redistribute it and/or modify it under the terms of the GNU
// Lesser General Public License as published by the Free Software Foundation, either version 3 of
// the License, or (at your option) any later version.
// 
// AceWiki is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
// even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License along with AceWiki. If
// not, see http://www.gnu.org/licenses/.

package ch.uzh.ifi.attempto.acewiki.aceowl;

import ch.uzh.ifi.attempto.acewiki.core.Sentence;
import ch.uzh.ifi.attempto.acewiki.core.SentenceSuggestion;

public class AToEverySuggestion implements SentenceSuggestion {
	
	private Sentence sentence;
	
	AToEverySuggestion(Sentence sentence) {
		this.sentence = sentence;
	}
	
	public String getMessage() {
		String s = sentence.getTextElements().get(1).getText();
		return "Your sentence \"a " + s + " ...\" is interpreted as \"there is a " + s +
			" that ...\". Do you want to say \"every " + s + " ...\"?";
	}
	
	public String[] getOptions() {
		return new String[] {"a ...", "every ..."};
	}
	
	public Sentence getSentence(String option) {
		if (option.equals("every ...")) {
			String text = sentence.getText();
			text = text.replaceFirst("^(A|a)n? ", "Every ");
			return sentence.getOntology().getStatementFactory().createSentence(
					text,
					sentence.getArticle()
				);
		}
		return sentence;
	}
	
}