var EditorQuestions = React.createClass({
    getInitialState: function() {
        return {items: this.props.items, current_selection: this.props.current_selection, event_slug: this.props.event_slug, event_id: this.props.event_id, category: 'question'}
    },
    render: function() {
        return (
            
            

             <div className="editor-tool editor-panel-left-nav" id="editor-tool-questions" >
               <EditorSection items={this.state.items} ticket_types={this.props.ticket_types} event_id={this.props.event_id} current_selection={this.state.current_selection} event_slug={this.state.event_slug} category={this.state.category} />
            
            </div> 


        )
    }
})
