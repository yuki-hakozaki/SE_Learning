import express, { Request, Response } from 'express';
import multer from 'multer';
import { v4 as uuid } from 'uuid';

const app = express();
app.use(multer().none());
app.use(express.static('web'));

interface TodoItem {
    id: string;
    title: string;
    done: boolean;
}

const todoList: TodoItem[] = [];

app.get('/api/v1/list', (req: Request, res: Response) => {
    res.json(todoList);
});

app.post('/api/v1/add', (req: Request, res: Response) => {
    const todoData = req.body;
    const todoTitle = todoData.title;

    const id = uuid();

    const todoItem: TodoItem = {
        id,
        title: todoTitle,
        done: false,
    };

    todoList.push(todoItem);
    console.log('Add: ' + JSON.stringify(todoItem));
    res.json(todoItem);
});

app.delete('/api/v1/item/:id', (req: Request, res: Response) => {
    const index = todoList.findIndex((item) => item.id === req.params.id);

    if (index >= 0) {
        const deleted = todoList.splice(index, 1);
        console.log('Delete: ' + JSON.stringify(deleted[0]));
    }

    res.sendStatus(200);
});

app.put('/api/v1/item/:id', (req: Request, res: Response) => {
    const index = todoList.findIndex((item) => item.id === req.params.id);

    if (index >= 0) {
        const item = todoList[index];
        if (req.body.done) {
            item.done = req.body.done === 'true';
        }
        console.log('Edit: ' + JSON.stringify(item));
    }

    res.sendStatus(200);
});

app.listen(3000, () => console.log('Listening on port 3000'));
